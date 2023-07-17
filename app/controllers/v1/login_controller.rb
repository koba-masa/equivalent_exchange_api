# frozen_string_literal: true

module V1
  class LoginController < ApplicationController
    def login
      user = ::User.find_by(login_id:)&.authenticate(password)
      if user.blank?
        render json: { error: 'unauthorized' }, status: :unauthorized
        return
      end

      payload = {
        iss: Settings.jwt.issuer,
        sub: user.id,
        exp: (DateTime.current + 14.days).to_i,
      }
      rsa_private = OpenSSL::PKey::RSA.new(Rails.root.join(Settings.jwt.private_key).read)
      token = JWT.encode(payload, rsa_private, Settings.jwt.algorithm)

      render json: { token: }, status: :created
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
