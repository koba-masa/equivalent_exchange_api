# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1, format: 'json' do
    post 'login', to: 'login#login'
    resources :categories, only: %i[index create]
  end
end
