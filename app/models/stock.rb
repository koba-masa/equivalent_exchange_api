# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :character

  validates :status, presence: true
  validates :image, presence: true
  validate :validate_status_when_canceled, on: :update, if: proc { |stock| stock.status_changed? && stock.canceled? }

  enum status: { untrading: 0, canceled: 10, trading: 20, traded: 30 }

  STATUS_LABEL = { untrading: '未交換', canceled: '取り下げ', trading: '交渉中', traded: '交換済み' }.freeze
  CAN_CANCEL_STATUSES = %w[untrading canceled].freeze

  scope :untrading, -> { where(status: :untrading) }

  def image_url
    "#{Settings.stock.image.domain}/#{Settings.aws.s3.stock_image_prefix}/#{image}"
  end

  def status_label
    # TODO: i18nとかで管理したい
    STATUS_LABEL[status.to_sym]
  end

  def can_cancel?
    CAN_CANCEL_STATUSES.include?(status_was)
  end

  private

  def validate_status_when_canceled
    errors.add(:status, 'can update only untrading stock') unless can_cancel?
  end
end
