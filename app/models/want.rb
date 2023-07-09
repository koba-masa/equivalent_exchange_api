# frozen_string_literal: true

class Want < ApplicationRecord
  validates :status, presence: true

  belongs_to :user
  belongs_to :character

  validates :status, presence: true
  validate :can_cancel?, on: :update, if: proc { |stock| stock.status_changed? && stock.canceled? }

  enum status: { untrading: 0, canceled: 10, trading: 20, traded: 30 }

  STATUS_LABEL = { untrading: '未交換', canceled: '取り下げ', trading: '交渉中', traded: '交換済み' }.freeze
  CAN_CANCEL_STATUSES = %w[untrading canceled].freeze

  def status_label
    # TODO: i18nとかで管理したい
    STATUS_LABEL[status.to_sym]
  end

  def can_cancel?
    CAN_CANCEL_STATUSES.include?(status_was)
  end

  private

  def validate_status_when_canceled
    errors.add(:status, 'can update only untrading want') unless can_cancel?
  end
end
