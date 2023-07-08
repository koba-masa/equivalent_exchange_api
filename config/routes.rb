# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1, format: 'json' do
    post 'login', to: 'login#login'

    resources :categories, only: %i[index create] do
      resources :goods, module: :category, only: %i[index create] do
        resources :characters, module: :good, only: %i[index create]
      end
    end

    resources :users do
      resources :stocks, module: :user, only: %i[index]
    end
  end
end
