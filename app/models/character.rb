# frozen_string_literal: true

class Character < ApplicationRecord
  belongs_to :good

  validates :name, presence: true, length: { maximum: 128 }, uniqueness: { scope: :good_id }
end
