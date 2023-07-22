# frozen_string_literal: true

module V1
  class TradingsController < ApplicationController
    # 相手の欲しいものをチェックする
    # 相手の欲しいグッズであること
    def create
      matching = VMatching.untrading.find_candidate_matching(user.id, my_want_id, your_stock_id, your_want_id,
                                                             my_stock_id)

      if matching.blank?
        # TODO: エラーメッセージの実装を行う&ステータスコードの見直しを行う
        render json: { errors: {} }, status: :not_found
        return
      end

      ActiveRecord::Base.transaction do
        @my_trading = Trading.create(
          want: lock_want(matching.my_want_id, :untrading),
          stock: lock_stock(matching.your_stock_id, :untrading),
          status: :trading,
        )
        @your_trading = Trading.create(
          want: lock_want(matching.your_want_id, :untrading),
          stock: lock_stock(matching.my_stock_id, :untrading),
          status: :trading,
        )
      end

      render json: {}, status: :ok
    rescue ActiveRecord::RecordNotFound
      # TODO: エラーメッセージの実装を行う
      render json: { errors: { message: '状態が更新されてしまいました' } }, status: :not_found
    end

    def update; end

    private

    def user
      @user ||= ::User.find(params[:user_id])
    end

    def lock_want(want_id, status)
      ::Want.lock.find_by!(id: want_id, status:)
    end

    def lock_stock(stock_id, status)
      ::Stock.lock.find_by!(id: stock_id, status:)
    end

    def trading
      @trading ||= ::Trading.find(params[:id])
    end

    def my_want_id
      params[:my_want_id]
    end

    def your_stock_id
      params[:your_stock_id]
    end

    def your_want_id
      params[:your_want_id]
    end

    def my_stock_id
      params[:my_stock_id]
    end
  end
end
