# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Category::Goods' do
  describe 'GET /v1/categories/:category_id/goods' do
    subject(:get_goods) { get v1_category_goods_path(category_id: category.id) }

    let(:category) { create(:category) }

    shared_examples 'get goods' do
      it do
        get_goods
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context 'when there are no goods' do
      let(:expected_response) do
        {
          'goods' => [],
        }
      end

      it_behaves_like 'get goods'
    end

    context 'when there are goods' do
      let(:good1) { create(:good, category:, name: '商品B') }
      let(:good2) { create(:good, category:, name: '商品A') }

      let(:expected_response) do
        {
          'goods' => [
            { 'category_id' => category.id, 'category_name' => category.name, 'id' => good2.id, 'name' => good2.name },
            { 'category_id' => category.id, 'category_name' => category.name, 'id' => good1.id, 'name' => good1.name },
          ],
        }
      end

      before do
        good1
        good2
      end

      it_behaves_like 'get goods'
    end
  end

  describe 'POST /v1/categories/:category_id/goods' do
    subject(:create_good) { post v1_category_goods_path(category_id:), params: }

    let(:category) { create(:category) }

    context 'when the good is created' do
      let(:params) { { good: { name: '商品A' } } }
      let(:category_id) { category.id }

      it 'returns the created category' do
        create_good
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['name']).to eq('商品A')
      end
    end

    context 'when the good of another category is already exists' do
      let(:params) { { good: { name: '商品A' } } }
      let(:category_id) { category.id }
      let(:another_category) { create(:category, name: 'カテゴリ999') }

      before { create(:good, name: '商品A', category: another_category) }

      it 'returns the created category' do
        create_good
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['name']).to eq('商品A')
      end
    end

    context 'when the good is already exists' do
      let(:params) { { good: { name: '商品A' } } }
      let(:category_id) { category.id }

      before { create(:good, name: '商品A', category:) }

      it 'returns the error' do
        create_good
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']['name']).to eq(['has already been taken'])
      end
    end

    context 'when category is not exists' do
      let(:params) { { good: { name: '商品A' } } }
      let(:category_id) { 0 }

      it 'returns the created category' do
        create_good
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']['category']).to eq(['does not exist'])
      end
    end
  end
end
