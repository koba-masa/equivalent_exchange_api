# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :character

  validates :status, presence: true
  validates :image, presence: true

  enum status: { in_stock: 0, cancel: 10, trading: 20, traded: 30 }

  def image_url
    "#{Settings.stock.image.domain}/#{Settings.aws.s3.stock_image_prefix}/#{image}"
  end
end
