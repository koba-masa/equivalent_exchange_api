# frozen_string_literal: true

module V1
  module User
    class StocksController < ApplicationController
      def index
        @stocks = ::Stock.where(user_id:).includes(character: { good: :category })
      end

      def show
        @stock = ::Stock.find_by!(user_id:, id: stock_id)
      rescue ActiveRecord::RecordNotFound
        render json: {}, status: :not_found
      end

      private

      def user_id
        params[:user_id]
      end

      def stock_id
        params[:id]
      end
    end
  end
end
