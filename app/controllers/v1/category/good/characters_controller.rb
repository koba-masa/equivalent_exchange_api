# frozen_string_literal: true

module V1
  module Category
    module Good
      class CharactersController < ApplicationController
        before_action :check_authentication

        def index
          @characters = Character.joins(good: :category).where('categories.id = ? and goods.id = ?', category_id,
                                                               good_id).includes(good: :category)
        end

        def create
          good = ::Good.find_by(id: good_id, category_id:)
          unless good
            render json: { errors: { good: ['does not exist'] } }, status: :bad_request
            return
          end
          @character = ::Character.new(character_params)
          @character.good = good
          @character.save!
        rescue ActiveRecord::RecordInvalid
          render json: { errors: @character.errors }, status: :bad_request
        end

        private

        def category_id
          params[:category_id]
        end

        def good_id
          params[:good_id]
        end

        def character_params
          params.require(:character).permit(:name)
        end
      end
    end
  end
end
