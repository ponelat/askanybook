Rails.application.routes.draw do
  get '/health', to: 'health#index'

  # Defines the root path route ("/")
  # root "articles#index"
end
