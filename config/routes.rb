# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1, format: 'json' do
    post 'login', to: 'login#login'
    resources :stocks, only: %i[index show create update]
    resources :wants, only: %i[index show create update]
    resources :tradings, only: %i[create update]
    resources :dealings, only: %i[create destroy] do
      patch :approve, on: :member
    end

    resources :categories, only: %i[index create] do
      resources :goods, module: :category, only: %i[index create] do
        resources :characters, module: :good, only: %i[index create]
      end
    end
  end
end
