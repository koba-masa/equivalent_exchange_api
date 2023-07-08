# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::User::Stocks' do
  let(:user) { create(:user, display_name: 'テスト用ユーザ') }
  let(:another_user) { create(:user, display_name: '別ユーザ') }
  let(:category1) { create(:category, name: 'カテゴリ1') }
  let(:category2) { create(:category, name: 'カテゴリ2') }
  let(:good1) { create(:good, name: 'グッズ1', category: category1) }
  let(:good2) { create(:good, name: 'グッズ2', category: category2) }
  let(:character1) { create(:character, name: 'キャラクター1', good: good1) }
  let(:character2) { create(:character, name: 'キャラクター2', good: good2) }

  describe 'GET /v1/users/:user_id/stocks' do
    subject(:get_stocks) { get v1_user_stocks_path(user_id:) }

    let(:user_id) { user.id }

    let(:stock1) { create(:stock, user:, character: character1, status: 0) }
    let(:stock2) { create(:stock, user:, character: character1, status: 20) }
    let(:stock3) { create(:stock, user: another_user, character: character2, status: 0) }

    context 'when user has stocks' do
      let(:expected_response) do
        {
          'stocks' => [
            { 'category_name' => category1.name, 'good_name' => good1.name, 'character_name' => character1.name,
              'id' => stock1.id, 'status' => stock1.status_label, 'image' => stock1.image_url },
            { 'category_name' => category1.name, 'good_name' => good1.name, 'character_name' => character1.name,
              'id' => stock2.id, 'status' => stock2.status_label, 'image' => stock2.image_url },
          ],
        }
      end

      before do
        stock1
        stock2
        stock3
      end

      it 'returns stocks' do
        get_stocks
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context 'when user does not have stocks' do
      let(:expected_response) { { 'stocks' => [] } }

      it 'returns empty array' do
        get_stocks
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(expected_response)
      end
    end
  end

  describe 'GET /v1/users/:user_id/stocks/:id' do
    subject(:get_stock) { get v1_user_stock_path(user_id:, id: stock_id) }

    let(:user_id) { user.id }
    let(:stock) { create(:stock, user:, character: character1, status: 0) }
    let(:another_user_stock) { create(:stock, user: another_user, character: character1, status: 0) }

    context 'when stock exists' do
      let(:stock_id) { stock.id }
      let(:expected_response) do
        {
          'category_name' => category1.name, 'good_name' => good1.name, 'character_name' => character1.name,
          'id' => stock.id, 'status' => stock.status_label, 'image' => stock.image_url
        }
      end

      it 'returns stock' do
        get_stock
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context 'when stock does not exist' do
      let(:stock_id) { 0 }
      let(:expected_response) { {} }

      it 'returns error' do
        get_stock
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context 'when stock belongs to another user' do
      let(:stock_id) { another_user_stock.id }
      let(:expected_response) { {} }

      it 'returns error' do
        get_stock
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to eq(expected_response)
      end
    end
  end

  describe 'POST /v1/users/:user_id/stocks' do
    subject(:create_stock) { post v1_user_stocks_path(user_id:), params: }

    let(:user_id) { user.id }

    context 'when user request one stock' do
      let(:params) do
        {
          stock: {
            character_id: character1.id,
            quantity: 1,
          },
        }
      end

      it 'returns stocks' do
        create_stock
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['stocks'].size).to eq(1)
      end
    end

    context 'when user request multiple stocks' do
      let(:params) do
        {
          stock: {
            character_id: character1.id,
            quantity: 10,
          },
        }
      end

      it 'returns stocks' do
        create_stock
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['stocks'].size).to eq(10)
      end
    end

    context 'when user request stock with invalid character id' do
      let(:params) do
        {
          stock: {
            character_id: 0,
            quantity: 10,
          },
        }
      end

      it 'returns error' do
        create_stock
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']['character']).to eq(['does not exist'])
      end
    end
  end
end
