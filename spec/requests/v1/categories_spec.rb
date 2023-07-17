# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Categories' do
  let(:headers) do
    {
      'Authorization' => "Bearer #{login(user.id)}",
    }
  end
  let(:user) { create(:user) }

  describe 'GET /v1/categories/index' do
    subject(:get_categories) { get v1_categories_url, headers: }

    shared_examples 'normal get categies' do
      it do
        get_categories
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context 'when there are no categories' do
      let(:expected_response) do
        { 'categories' => [] }
      end

      it_behaves_like 'normal get categies'
    end

    context 'when there are categories' do
      let(:category1) { create(:category, name: 'カテゴリB') }
      let(:category2) { create(:category, name: 'カテゴリA') }

      let(:expected_response) do
        {
          'categories' => [
            { 'id' => category2.id, 'name' => 'カテゴリA' },
            { 'id' => category1.id, 'name' => 'カテゴリB' },
          ],
        }
      end

      before do
        category1
        category2
      end

      it_behaves_like 'normal get categies'
    end
  end

  describe 'POST /v1/categories' do
    subject(:create_category) { post v1_categories_url, params:, headers: }

    context 'when the category is created' do
      let(:params) { { category: { name: 'カテゴリA' } } }

      it 'returns the created category' do
        create_category
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['name']).to eq('カテゴリA')
      end
    end

    context 'when the category is already exists' do
      let(:params) { { category: { name: 'カテゴリA' } } }

      before { create(:category, name: 'カテゴリA') }

      it 'returns the error' do
        create_category
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']['name']).to eq(['has already been taken'])
      end
    end
  end
end
