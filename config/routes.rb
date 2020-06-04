Rails.application.routes.draw do
  resources :posts

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
