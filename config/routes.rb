Rails.application.routes.draw do
  get '/home/show', as: 'home'

  root 'sessions#new'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resource :forgot_passwords, only: [:new, :create]

  get '/reset_password/:challenge', to: 'reset_passwords#new', as: 'reset_password'
  resource :reset_passwords , only: [:create]

  get '/magic_link/:challenge', to: 'magic_links#new', as: 'magic_link'
end
