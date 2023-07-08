# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :character

  validates :status, presence: true
  validates :image, presence: true

  enum status: { in_stock: 0, cancel: 10, trading: 20, traded: 30 }

  STATUS_LABEL = { in_stock: '未交換', cancel: '取り下げ', trading: '交渉中', traded: '交換済み' }.freeze

  def image_url
    "#{Settings.stock.image.domain}/#{Settings.aws.s3.stock_image_prefix}/#{image}"
  end

  def status_label
    # TODO: i18nとかで管理したい
    STATUS_LABEL[status.to_sym]
  end
end
