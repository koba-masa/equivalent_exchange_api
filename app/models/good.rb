# frozen_string_literal: true

class Good < ApplicationRecord
  belongs_to :category

  validates :name, presence: true, length: { maximum: 128 }, uniqueness: { scope: :category_id }
end
