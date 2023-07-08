# frozen_string_literal: true

module V1
  class CategoriesController < ApplicationController
    def index
      @categories = Category.all
    end

    def create
      @category = Category.new(category_params)
      @category.save!
    rescue ActiveRecord::RecordInvalid
      render json: { errors: @category.errors }, status: :bad_request
    end

    private

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
