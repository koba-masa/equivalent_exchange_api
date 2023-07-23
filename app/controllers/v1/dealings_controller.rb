# frozen_string_literal: true

module V1
  class DealingsController < ApplicationController
    before_action :check_authentication

    def create
      matching = VMatching.untrading.find_candidate_matching!(
        current_user.id,
        applicant_want_id,
        partner_stock_id,
        partner_want_id,
        applicant_stock_id,
      )

      ::Dealing.applicate(
        current_user.id,
        matching.your_user_id,
        matching.my_want_id,
        matching.your_stock_id,
        matching.your_want_id,
        matching.my_stock_id,
      )

      render json: {}, status: :ok
    rescue ActiveRecord::RecordNotFound
      # TODO: エラーメッセージの実装を行う
      render json: { errors: { message: '状態が更新されてしまいました' } }, status: :not_found
    end

    private

    def applicant_want_id
      params[:my_want_id]
    end

    def partner_stock_id
      params[:your_stock_id]
    end

    def partner_want_id
      params[:your_want_id]
    end

    def applicant_stock_id
      params[:my_stock_id]
    end
  end
end
