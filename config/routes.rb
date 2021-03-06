Rails.application.routes.draw do

  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :posts, only: :index
  end

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :posts do
      resources :likes, only: %i[create destroy]
    end
    get '/feed', to: 'posts#feed'

    post '/follow', to: 'follows#create'
    delete '/follow', to: 'follows#destroy'
  end

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  get '/users/:username', to: 'users#show'
  put '/users/:username/avatar', to: 'users#change_avatar'
end
