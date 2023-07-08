# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :character

  validates :status, presence: true
  validates :image, presence: true
  validate :can_cancel?, on: :update, if: proc { |stock| stock.status_changed? && stock.canceled? }

  enum status: { in_stock: 0, canceled: 10, trading: 20, traded: 30 }

  STATUS_LABEL = { in_stock: '未交換', canceled: '取り下げ', trading: '交渉中', traded: '交換済み' }.freeze
  CAN_CANCEL_STATUSES = %w[in_stock canceled].freeze

  def image_url
    "#{Settings.stock.image.domain}/#{Settings.aws.s3.stock_image_prefix}/#{image}"
  end

  def status_label
    # TODO: i18nとかで管理したい
    STATUS_LABEL[status.to_sym]
  end

  def can_cancel?
    errors.add(:status, 'can update only in_stock stock') unless CAN_CANCEL_STATUSES.include?(status_was)
  end
end
