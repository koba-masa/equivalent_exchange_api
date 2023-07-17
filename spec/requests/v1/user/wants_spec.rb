# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::User::Wants' do
  let(:headers) { { 'Authorization' => "Bearer #{login(user_id)}" } }
  let(:user) { create(:user, display_name: 'テスト用ユーザ') }
  let(:another_user1) { create(:user, display_name: '別ユーザ1') }
  let(:another_user2) { create(:user, display_name: '別ユーザ2') }
  let(:category1) { create(:category, name: 'カテゴリ1') }
  let(:category2) { create(:category, name: 'カテゴリ2') }
  let(:good1) { create(:good, name: 'グッズ1', category: category1) }
  let(:good2) { create(:good, name: 'グッズ2', category: category2) }
  let(:character1) { create(:character, name: 'キャラクター1', good: good1) }
  let(:character2) { create(:character, name: 'キャラクター2', good: good2) }

  describe 'GET /v1/users/:user_id/wants' do
    subject(:get_wants) { get v1_user_wants_path(user_id:), headers: }

    let(:user_id) { user.id }

    let(:want1) { create(:want, user:, character: character1, status: 0) }
    let(:want2) { create(:want, user:, character: character1, status: 20) }
    let(:want3) { create(:want, user: another_user1, character: character2, status: 0) }

    context 'when user has wants' do
      let(:expected_response) do
        {
          'wants' => [
            { 'category_name' => category1.name, 'good_name' => good1.name, 'character_name' => character1.name,
              'id' => want1.id, 'status' => want1.status_label },
            { 'category_name' => category1.name, 'good_name' => good1.name, 'character_name' => character1.name,
              'id' => want2.id, 'status' => want2.status_label },
          ],
        }
      end

      before do
        want1
        want2
        want3
      end

      it 'returns wants' do
        get_wants
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context 'when user does not have wants' do
      let(:expected_response) { { 'wants' => [] } }

      it 'returns empty array' do
        get_wants
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(expected_response)
      end
    end
  end

  describe 'GET /v1/users/:user_id/wants/:id' do
    subject(:get_want) { get v1_user_want_path(user_id:, id: want_id), headers: }

    let(:user_id) { user.id }
    let(:want_with_stocks) { create(:want, user:, character: character1, status: 0) }
    let(:want_without_stocks) { create(:want, user:, character: character2, status: 0) }
    let(:another_user_want) { create(:want, user: another_user1, character: character1, status: 0) }

    let(:user_stock_untrading) { create(:want, user:, character: character1, status: 0) }
    let(:another_user1_stock_untrading1) { create(:stock, user: another_user1, character: character1, status: 0) }
    let(:another_user1_stock_untrading2) { create(:stock, user: another_user1, character: character1, status: 0) }
    let(:another_user2_stock_untrading1) { create(:stock, user: another_user2, character: character1, status: 0) }

    before do
      user_stock_untrading

      another_user1_stock_untrading1
      another_user1_stock_untrading2
      another_user2_stock_untrading1
    end

    context 'when want exists' do
      shared_examples 'returns want' do
        it do
          get_want
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq(expected_response)
        end
      end

      context 'with stock' do
        let(:want_id) { want_with_stocks.id }
        let(:expected_response) do
          {
            'category_name' => category1.name, 'good_name' => good1.name, 'character_name' => character1.name,
            'id' => want_with_stocks.id, 'status' => want_with_stocks.status_label,
            'stocks' => [
              {
                'id' => another_user1_stock_untrading1.id,
                'user_name' => another_user1_stock_untrading1.user.display_name,
                'status' => another_user1_stock_untrading1.status_label,
                'image' => another_user1_stock_untrading1.image_url,
              },
              {
                'id' => another_user1_stock_untrading2.id,
                'user_name' => another_user1_stock_untrading2.user.display_name,
                'status' => another_user1_stock_untrading2.status_label,
                'image' => another_user1_stock_untrading2.image_url,
              },
              {
                'id' => another_user2_stock_untrading1.id,
                'user_name' => another_user2_stock_untrading1.user.display_name,
                'status' => another_user2_stock_untrading1.status_label,
                'image' => another_user2_stock_untrading1.image_url,
              },
            ]
          }
        end

        it_behaves_like 'returns want'
      end

      context 'without stock' do
        let(:want_id) { want_without_stocks.id }
        let(:expected_response) do
          {
            'category_name' => category2.name, 'good_name' => good2.name, 'character_name' => character2.name,
            'id' => want_without_stocks.id, 'status' => want_without_stocks.status_label, 'stocks' => []
          }
        end

        it_behaves_like 'returns want'
      end
    end

    context 'when want does not exist' do
      let(:want_id) { 0 }
      let(:expected_response) { {} }

      it 'returns error' do
        get_want
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context 'when want belongs to another user' do
      let(:want_id) { another_user_want.id }
      let(:expected_response) { {} }

      it 'returns error' do
        get_want
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to eq(expected_response)
      end
    end
  end

  describe 'POST /v1/users/:user_id/wants' do
    subject(:create_want) { post v1_user_wants_path(user_id:), params:, headers: }

    let(:user_id) { user.id }

    context 'when user request one want' do
      let(:params) do
        {
          want: {
            character_id: character1.id,
            quantity: 1,
          },
        }
      end

      it 'returns wants' do
        create_want
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['wants'].size).to eq(1)
      end
    end

    context 'when user request multiple wants' do
      let(:params) do
        {
          want: {
            character_id: character1.id,
            quantity: 10,
          },
        }
      end

      it 'returns wants' do
        create_want
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['wants'].size).to eq(10)
      end
    end

    context 'when user request want with invalid character id' do
      let(:params) do
        {
          want: {
            character_id: 0,
            quantity: 10,
          },
        }
      end

      it 'returns error' do
        create_want
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']['character']).to eq(['does not exist'])
      end
    end
  end

  describe 'PATCH /v1/users/:user_id/wants/:id' do
    subject(:update_want) { patch v1_user_want_path(user_id:, id: want_id), params:, headers: }

    let(:user_id) { user.id }

    let(:user_want_untrading) { create(:want, user:, character: character1, status: 0) }
    let(:user_want_canceled) { create(:want, user:, character: character1, status: 10) }
    let(:user_want_trading) { create(:want, user:, character: character1, status: 20) }
    let(:user_want_traded) { create(:want, user:, character: character1, status: 30) }
    let(:another_user_want) { create(:want, user: another_user1, character: character1, status: 20) }

    let(:params) do
      {
        want: {
          id: want_id,
        },
      }
    end

    context 'when want belongs to user' do
      shared_examples 'can not update want to canceled' do
        it do
          update_want
          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body['errors']['status']).to eq(['can update only untrading want'])
        end
      end

      context 'when want is untrading' do
        let(:want_id) { user_want_untrading.id }

        it 'returns wants' do
          update_want
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['status']).to eq('取り下げ')
        end
      end

      # TODO: 取り下げを取り下げに変更することはできるのか?
      context 'when want is canceled' do
        let(:want_id) { user_want_canceled.id }

        it 'returns wants' do
          update_want
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['status']).to eq('取り下げ')
        end
      end

      context 'when want is trading' do
        let(:want_id) { user_want_trading.id }

        it_behaves_like 'can not update want to canceled'
      end

      context 'when want is traded' do
        let(:want_id) { user_want_traded.id }

        it_behaves_like 'can not update want to canceled'
      end
    end

    context 'when want belongs to another user' do
      let(:want_id) { another_user_want.id }

      it 'returns error' do
        update_want
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to eq({})
      end
    end

    context 'when want does not exist' do
      let(:want_id) { 0 }

      it 'returns error' do
        update_want
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to eq({})
      end
    end
  end
end
