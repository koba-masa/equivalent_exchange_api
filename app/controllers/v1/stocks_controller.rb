# frozen_string_literal: true

module V1
  class StocksController < ApplicationController
    before_action :check_authentication

    def index
      @stocks = ::Stock.where(user_id: current_user.id).includes(character: { good: :category })
    end

    def show
      @stock = ::Stock.find_by!(user_id: current_user.id, id: stock_id)
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end

    def create
      @created_stocks = []
      character = ::Character.includes(good: :category).find(character_id)
      quantity.times do
        stock = ::Stock.create(
          user: current_user,
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
      @stock = ::Stock.includes(character: { good: :category }).find_by!(user_id: current_user.id, id: stock_id)
      @stock.update!(status: :canceled)
    rescue ActiveRecord::RecordNotFound
      # TODO: エラーメッセージの実装を行う
      render json: {}, status: :not_found
    rescue ActiveRecord::RecordInvalid
      render json: { errors: @stock.errors }, status: :bad_request
    end

    private

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
