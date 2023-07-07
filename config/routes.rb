# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1 do
    post 'login', to: 'login#login'
  end
end
