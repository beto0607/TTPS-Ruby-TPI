Rails.application.routes.draw do
  #  post 'user_token' => 'user_token#create'
  
  resources :users, only: ['create', 'index'] #For signup
  post '/sessions' => 'user_token#create' #For login
  #resources :questions, only:['index', 'show', 'create', 'update', 'detroy']
  resources :questions, only:['index', 'show', 'create', 'update', 'detroy'] do
    put '/resolve', to: 'question#resolve'
    resources :answers, only: ['index', 'destroy', 'create']
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
