# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :login_id, presence: true, uniqueness: true, length: { maximum: 128 }
  validates :password_digest, presence: true
  validates :display_name, presence: true, length: { maximum: 128 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 512 }
end
