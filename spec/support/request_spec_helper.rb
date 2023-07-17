# frozen_string_literal: true

module RequestSpecHelper
  def login(user_id)
    payload = {
      iss: Settings.jwt.issuer,
      sub: user_id,
      exp: (DateTime.current + 14.days).to_i,
    }
    rsa_private = OpenSSL::PKey::RSA.new(Rails.root.join(Settings.jwt.private_key).read)
    JWT.encode(payload, rsa_private, Settings.jwt.algorithm)
  end
end
