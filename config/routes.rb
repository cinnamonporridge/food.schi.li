Rails.application.routes.draw do
  root "sessions#new"

  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  resource :forgot_passwords, only: %i[new create]
  get "/reset_password/:challenge", to: "reset_passwords#new", as: "reset_password"
  resource :reset_passwords, only: [:create]

  resources :settings, only: :index

  resources :recipes do
    resources :ingredients, only: %i[new create edit update destroy], module: :recipes
    resource :copy, only: %i[new create], module: :recipes
  end

  resources :foods do
    resources :portions, except: %i[index show]
    post :globalize, on: :member
  end

  resources :journal_days do
    resources :meals, except: %i[index show]
  end

  resources :meals do
    resources :ingredients, only: %i[new create edit update destroy], module: :meals
  end

  resources :day_partitions, except: :show

  namespace :user do
    resource :profile, only: %i[show update]
  end
end
