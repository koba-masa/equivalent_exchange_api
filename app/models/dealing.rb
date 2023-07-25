# frozen_string_literal: true

class Dealing < ApplicationRecord
  belongs_to :applicant_want, class_name: 'Want'
  belongs_to :partner_stock, class_name: 'Stock'
  belongs_to :partner_want, class_name: 'Want'
  belongs_to :applicant_stock, class_name: 'Stock'

  validates :status, presence: true

  enum status: { application: 20, approval: 30, trading: 40, traded: 50 }

  STATUS_LABEL = { application: '申請中', approval: '承諾済み', dealing: '交換中', dealed: '交換済み' }.freeze

  def status_label
    # TODO: i18nとかで管理したい
    STATUS_LABEL[status.to_sym]
  end

  def self.applicate(applicant, partner, applicant_want_id, partner_stock_id, partner_want_id, applicant_stock_id)
    ActiveRecord::Base.transaction do
      applicant_want = lock_want(applicant, applicant_want_id, :untrading)
      partner_stock = lock_stock(partner, partner_stock_id, :untrading)
      partner_want = lock_want(partner, partner_want_id, :untrading)
      applicant_stock = lock_stock(applicant, applicant_stock_id, :untrading)
      partner_want.update(status: :trading)
      partner_stock.update(status: :trading)
      applicant_want.update(status: :trading)
      applicant_stock.update(status: :trading)
      create(
        applicant_want:,
        partner_stock:,
        partner_want:,
        applicant_stock:,
        status: :application,
      )
    end
  end

  def approve(partner)
    raise StandardError unless partner.id == partner_stock.user_id

    ActiveRecord::Base.transaction do
      applicant_want.update(status: :traded)
      partner_stock.update(status: :traded)
      partner_want.update(status: :traded)
      applicant_stock.update(status: :traded)
      update(status: :approval)
    end
  end

  def deny(partner)
    raise StandardError unless partner.id == partner_stock.user_id

    ActiveRecord::Base.transaction do
      applicant_want.update(status: :untrading)
      partner_stock.update(status: :untrading)
      partner_want.update(status: :untrading)
      applicant_stock.update(status: :untrading)
      destroy
    end
  end

  def self.lock_want(user, id, status)
    ::Want.lock.find_by!(user:, id:, status:)
  end

  def self.lock_stock(user, id, status)
    ::Stock.lock.find_by!(user:, id:, status:)
  end
end
