Rails.application.routes.draw do
  post '/sessions' => 'user_token#create' #For login
  jsonapi_resources :questions, only:['index', 'show', 'create', 'update', 'detroy'] do
    jsonapi_resources :answers, only: ['index', 'destroy', 'create']do
    end
    put '/resolve', to: 'question#resolve'
  end
end
