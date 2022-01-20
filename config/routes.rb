Rails.application.routes.draw do
  root 'sessions#new'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resource :forgot_passwords, only: %i[new create]
  get '/reset_password/:challenge', to: 'reset_passwords#new', as: 'reset_password'
  resource :reset_passwords, only: [:create]

  resources :settings, only: :index

  resources :recipes do
    resources :ingredients, except: [:index, :show]
    resource :copy, only: %i[new create], module: :recipes
  end

  resources :foods do
    resources :portions, except: [:index, :show]
    resources :recipes, only: [:index], module: :foods
    resources :journal_days, only: [:index], module: :foods
  end

  resources :journal_days do
    resources :portion_meals, only: %i[new create], module: :journal_days
    resources :recipe_meals, only: %i[new create], module: :journal_days
  end

  resources :meals, only: :destroy do
    resources :ingredients, only: %i[new create edit update destroy], module: :meals
  end

  resources :day_partitions
end
