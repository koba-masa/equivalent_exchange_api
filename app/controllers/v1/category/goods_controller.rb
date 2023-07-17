# frozen_string_literal: true

module V1
  module Category
    class GoodsController < ApplicationController
      before_action :check_authentication

      def index
        @goods = ::Good.where(category_id:).includes(:category)
      end

      def create
        category = ::Category.find(category_id)
        @good = ::Good.new(good_params)
        @good.category = category
        @good.save!
      rescue ActiveRecord::RecordNotFound
        render json: { errors: { category: ['does not exist'] } }, status: :bad_request
      rescue ActiveRecord::RecordInvalid
        render json: { errors: @good.errors }, status: :bad_request
      end

      private

      def good_params
        params.require(:good).permit(:name)
      end

      def category_id
        params[:category_id]
      end
    end
  end
end
