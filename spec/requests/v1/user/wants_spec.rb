# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::User::Wants' do
  let(:user) { create(:user, display_name: 'テスト用ユーザ') }
  let(:another_user) { create(:user, display_name: '別ユーザ') }
  let(:category1) { create(:category, name: 'カテゴリ1') }
  let(:category2) { create(:category, name: 'カテゴリ2') }
  let(:good1) { create(:good, name: 'グッズ1', category: category1) }
  let(:good2) { create(:good, name: 'グッズ2', category: category2) }
  let(:character1) { create(:character, name: 'キャラクター1', good: good1) }
  let(:character2) { create(:character, name: 'キャラクター2', good: good2) }

  describe 'GET /v1/users/:user_id/wants' do
    subject(:get_wants) { get v1_user_wants_path(user_id:) }

    let(:user_id) { user.id }

    let(:want1) { create(:want, user:, character: character1, status: 0) }
    let(:want2) { create(:want, user:, character: character1, status: 20) }
    let(:want3) { create(:want, user: another_user, character: character2, status: 0) }

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
    subject(:get_want) { get v1_user_want_path(user_id:, id: want_id) }

    let(:user_id) { user.id }
    let(:want) { create(:want, user:, character: character1, status: 0) }
    let(:another_user_want) { create(:want, user: another_user, character: character1, status: 0) }

    context 'when want exists' do
      let(:want_id) { want.id }
      let(:expected_response) do
        {
          'category_name' => category1.name, 'good_name' => good1.name, 'character_name' => character1.name,
          'id' => want.id, 'status' => want.status_label
        }
      end

      it 'returns want' do
        get_want
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(expected_response)
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
    subject(:create_want) { post v1_user_wants_path(user_id:), params: }

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
    subject(:update_want) { patch v1_user_want_path(user_id:, id: want_id), params: }

    let(:user_id) { user.id }

    let(:user_want_untrading) { create(:want, user:, character: character1, status: 0) }
    let(:user_want_canceled) { create(:want, user:, character: character1, status: 10) }
    let(:user_want_trading) { create(:want, user:, character: character1, status: 20) }
    let(:user_want_traded) { create(:want, user:, character: character1, status: 30) }
    let(:another_user_want) { create(:want, user: another_user, character: character1, status: 20) }

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
