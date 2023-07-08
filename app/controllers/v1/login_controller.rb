# frozen_string_literal: true

module V1
  class LoginController < ApplicationController
    def login
      user = ::User.find_by(login_id:)
      if user&.authenticate(password)
        # TODO: Implement JWT
        render json: { token: 'token' }
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end

    private

    def login_id
      params[:login_id]
    end

    def password
      params[:password]
    end
  end
end
