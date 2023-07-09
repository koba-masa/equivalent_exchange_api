# frozen_string_literal: true

module V1
  module User
    class StocksController < ApplicationController
      def index
        @stocks = ::Stock.where(user_id: user.id).includes(character: { good: :category })
      end

      def show
        @stock = ::Stock.find_by!(user_id: user.id, id: stock_id)
      rescue ActiveRecord::RecordNotFound
        render json: {}, status: :not_found
      end

      def create
        @created_stocks = []
        character = ::Character.includes(good: :category).find(character_id)
        quantity.times do
          stock = ::Stock.create(
            user:,
            character:,
            status: :untrading,
            image: 'sample.png', # TODO: 画像のアップロード機能を実装する&サムネイルを生成する
          )
          @created_stocks.push(stock)
        end
      rescue ActiveRecord::RecordNotFound
        render json: { errors: { character: ['does not exist'] } }, status: :bad_request
      end

      def update
        @stock = ::Stock.includes(character: { good: :category }).find_by!(user_id: user.id, id: stock_id)
        @stock.update!(status: :canceled)
      rescue ActiveRecord::RecordNotFound
        # TODO: エラーメッセージの実装を行う
        render json: {}, status: :not_found
      rescue ActiveRecord::RecordInvalid
        render json: { errors: @stock.errors }, status: :bad_request
      end

      private

      # TODO: このメソッドは ApplicationController に移動する
      # 登録に使用するIDhはDBから再取得する
      def user
        ::User.find(params[:user_id])
      end

      def stock_id
        params[:id]
      end

      def character_id
        params[:stock][:character_id]
      end

      def quantity
        params[:stock][:quantity].to_i
      end
    end
  end
end
