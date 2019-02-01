Rails.application.routes.draw do
  post 'sessions' => 'user_token#create'
#  post 'user_token' => 'user_token#create'
  
  resources :answers
  resources :questions
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
