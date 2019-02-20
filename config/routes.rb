Rails.application.routes.draw do
  post '/sessions' => 'user_token#create' #For login
  jsonapi_resources :users, only:['create']do end
  jsonapi_resources :questions, only:['index', 'show', 'create', 'update', 'destroy'] do
    jsonapi_resources :answers, only: ['index', 'destroy', 'create']do
    end
    put '/resolve', to: 'questions#resolve'
  end
end
