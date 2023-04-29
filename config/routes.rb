# frozen_string_literal: true

Rails.application.routes.draw do
  get '/health', to: 'health#index'

  # Catch-all for Frontend
  get '/', to: 'static#index' # This is needed to handle React Router routes.
  get '*path', to: 'static#index', via: :all # This is needed to handle React Router routes.
end
