Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/users', to: "user#new"
  post '/sessions', to: "user#login"


  get '/questions', to: 'questions#index'
  get '/questions/:id', to: 'questions#show'
  post '/questions', to: 'questions#new'
  put '/questions/:id', to: 'questions#edit'
  delete '/questions/:id', to: 'questions#destroy'
  put '/questions/:id/resolve', to: 'questions#update'


  get '/questions/:question_id/answers', to:'answers#index'
  post '/questions/:question_id/answers', to:'answers#new'
  delete '/questions/:question_id/answers/:id', to:'answers#delete'
end
