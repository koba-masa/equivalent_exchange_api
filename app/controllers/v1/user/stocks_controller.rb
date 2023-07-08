# frozen_string_literal: true

module V1
  module User
    class StocksController < ApplicationController
      def index
        @stocks = ::Stock.where(user_id:).includes(character: { good: :category })
      end

      private

      def user_id
        params[:user_id]
      end
    end
  end
end
