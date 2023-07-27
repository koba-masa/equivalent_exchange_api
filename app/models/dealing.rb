# frozen_string_literal: true

class Dealing < ApplicationRecord
  belongs_to :applicant, class_name: 'User'
  belongs_to :want
  belongs_to :stock
  belongs_to :dealing, optional: true

  validates :status, presence: true

  enum status: { application: 20, approval: 30, trading: 40, traded: 50 }

  STATUS_LABEL = { application: '申請中', approval: '承諾済み', trading: '交換中', traded: '交換済み' }.freeze

  def status_label
    # TODO: i18nとかで管理したい
    STATUS_LABEL[status.to_sym]
  end

  def self.applicate(applicant, wanter, stocker, want_id, stock_id, dealing)
    ActiveRecord::Base.transaction do
      want = lock_want(wanter, want_id, :untrading)
      stock = lock_stock(stocker, stock_id, :untrading)
      want.update(status: :trading)
      stock.update(status: :trading)
      create(
        applicant:,
        want:,
        stock:,
        dealing:,
        status: :application,
      )
    end
  end

  def approve
    ActiveRecord::Base.transaction do
      want.update(status: :traded)
      stock.update(status: :traded)
      update(status: :approval)
    end
  end

  def deny
    ActiveRecord::Base.transaction do
      concerned_dealing = ::Dealing.find_by(dealing: self)
      concerned_dealing.update(dealing: nil) if concerned_dealing.present?
      want.update(status: :untrading)
      stock.update(status: :untrading)
      destroy
    end
  end

  def self.lock_want(user, id, status)
    ::Want.lock.find_by!(user:, id:, status:)
  end

  def self.lock_stock(user, id, status)
    ::Stock.lock.find_by!(user:, id:, status:)
  end

  def dealings
    dealings = []
    next_dealing = self

    loop do
      dealings.push(next_dealing)
      next_dealing = next_dealing.dealing
      break if next_dealing == self
    end

    dealings
  end
end
