Rails.application.routes.draw do
  root 'sessions#new'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resource :forgot_passwords, only: [:new, :create]

  get '/reset_password/:challenge', to: 'reset_passwords#new', as: 'reset_password'
  resource :reset_passwords, only: [:create]

  resources :users
  resources :recipes do
    resources :ingredients, except: [:index, :show]
    resource :copy, only: %i[new create], module: :recipes
  end

  resources :nutritions do
    resources :portions, except: [:index, :show]
    resources :recipes, only: [:index], module: :nutritions
    resources :journal_days, only: [:index], module: :nutritions
  end

  namespace :my do
    resources :journal_days do
      resources :meals, except: [:index, :show]
      resources :recipes, only: [:new, :create, :destroy], module: :journal_days
    end
  end
end
