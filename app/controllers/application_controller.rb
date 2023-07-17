# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionController::Cookies

  def check_authentication
    token = request.headers['Authorization']&.split(' ')&.last
    if token.blank?
      render json: {}, status: :unauthorized
      return
    end

    rsa_private = OpenSSL::PKey::RSA.new(Rails.root.join(Settings.jwt.private_key).read)
    begin
      decoded_token = ::JWT.decode(token, rsa_private, true, { algorithm: Settings.jwt.algorithm })
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
      render json: {}, status: :unauthorized
      return
    end

    @user_id = decoded_token.first['sub']
    render json: {}, status: :unauthorized if current_user.blank?
  end

  def current_user
    @current_user ||= User.find_by(id: @user_id)
  end
end
