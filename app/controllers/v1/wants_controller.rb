# frozen_string_literal: true

module V1
  class WantsController < ApplicationController
    before_action :check_authentication

    def index
      @wants = ::Want.where(user_id: current_user.id).includes(character: { good: :category })
    end

    def show
      @want = ::Want.find_by!(user_id: current_user.id, id: want_id)
      @candidates = ::VMatching.candidate_matchings_by_want(current_user.id, @want.id)
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end

    def create
      @created_wants = []
      character = ::Character.includes(good: :category).find(character_id)
      quantity.times do
        want = ::Want.create(
          user: current_user,
          character:,
          status: :untrading,
        )
        @created_wants.push(want)
      end
    rescue ActiveRecord::RecordNotFound
      render json: { errors: { character: ['does not exist'] } }, status: :bad_request
    end

    def update
      @want = ::Want.includes(character: { good: :category }).find_by!(user_id: current_user.id, id: want_id)
      @want.update!(status: :canceled)
    rescue ActiveRecord::RecordNotFound
      # TODO: エラーメッセージの実装を行う
      render json: {}, status: :not_found
    rescue ActiveRecord::RecordInvalid
      render json: { errors: @want.errors }, status: :bad_request
    end

    private

    # TODO: このメソッドは ApplicationController に移動する
    # 登録に使用するIDhはDBから再取得する
    def user
      ::User.find(params[:user_id])
    end

    def want_id
      params[:id]
    end

    def character_id
      params[:want][:character_id]
    end

    def quantity
      params[:want][:quantity].to_i
    end
  end
end
