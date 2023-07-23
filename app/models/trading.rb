# frozen_string_literal: true

class Trading < ApplicationRecord
  belongs_to :want
  belongs_to :stock
  belongs_to :trading, optional: true

  before_save :update_want_stock_status_to_trading
  before_create :update_want_stock_status_to_trading
  before_update :update_want_stock_status_to_traded, if: :update_status_to_traded?
  before_destroy :update_want_stock_status_to_untrading

  validates :status, presence: true

  enum status: { trading: 20, traded: 30, done: 40 }

  STATUS_LABEL = { trading: '交渉中', traded: '交換済み', done: '完了' }.freeze

  def status_label
    # TODO: i18nとかで管理したい
    STATUS_LABEL[status.to_sym]
  end

  def update_want_stock_status_to_trading
    want.update(status: :trading)
    stock.update(status: :trading)
  end

  def update_want_stock_status_to_traded
    want.update(status: :traded)
    stock.update(status: :traded)
  end

  def update_want_stock_status_to_untrading
    want.update(status: :untrading)
    stock.update(status: :untrading)
  end

  def update_status_to_traded?
    status_changed? && traded?
  end
end
