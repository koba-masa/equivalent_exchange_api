# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins Settings.cors.origins
    resource '*', headers: :any, methods: :any
  end
end
