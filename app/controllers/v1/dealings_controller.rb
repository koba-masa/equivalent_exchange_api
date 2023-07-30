# frozen_string_literal: true

module V1
  class DealingsController < ApplicationController
    before_action :check_authentication

    def create # rubocop:disable Metrics/MethodLength
      matching = VMatching.untrading.find_candidate_matching!(
        current_user.id,
        applicant_want_id,
        partner_stock_id,
        partner_want_id,
        applicant_stock_id,
      )

      ActiveRecord::Base.transaction do
        applicant_dealing = ::Dealing.applicate(
          current_user,
          current_user,
          matching.your_user_id,
          matching.my_want_id,
          matching.your_stock_id,
          nil,
        )

        partner_dealing = ::Dealing.applicate(
          current_user,
          matching.your_user_id,
          current_user,
          matching.your_want_id,
          matching.my_stock_id,
          applicant_dealing,
        )

        applicant_dealing.update(dealing: partner_dealing)
      end

      render json: {}, status: :ok
    rescue ActiveRecord::RecordNotFound
      # TODO: エラーメッセージの実装を行う
      render json: { errors: { message: '状態が更新されてしまいました' } }, status: :not_found
    end

    # TODO: 申請者が承認できないようにする
    def approve
      dealing = ::Dealing.find(params[:id])
      concerned_dealings = dealing.dealings

      ActiveRecord::Base.transaction do
        ::Dealing.lock.find(concerned_dealings)
        dealing.approve

        approval_count = concerned_dealings.count(&:approval?)

        if approval_count == (concerned_dealings.count - 1)
          concerned_dealings.each do |concerned_dealing|
            concerned_dealing.update(status: :trading)
          end
        end
      end

      render json: {}, status: :ok
    rescue StandardError
      render json: { errors: {} }, status: :forbidden
    end

    # TODO: 申請者が拒否できないようにする
    def destroy
      dealing = ::Dealing.find(params[:id])
      concerned_dealings = dealing.dealings

      ActiveRecord::Base.transaction do
        ::Dealing.lock.find(concerned_dealings)
        concerned_dealings.each(&:deny)
      end

      render json: {}, status: :ok
    rescue StandardError
      render json: { errors: {} }, status: :forbidden
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
