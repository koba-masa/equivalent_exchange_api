# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Logins' do
  describe 'POST /v1/login' do
    subject(:login) { post v1_login_url, params: }

    let(:valid_user) { create(:user) }

    context 'when login_id and password are correct' do
      let(:params) { { login_id: valid_user.login_id, password: valid_user.password } }

      it 'returns http success' do
        login
        expect(response).to have_http_status(:success)
      end
    end

    context 'when login_id is incorrect' do
      let(:params) { { login_id: 'invalid', password: valid_user.password } }

      it 'returns http unauthorized' do
        login
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when password is incorrect' do
      let(:params) { { login_id: valid_user.login_id, password: 'invalid' } }

      it 'returns http unauthorized' do
        login
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
