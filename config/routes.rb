Rails.application.routes.draw do

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/users/:username' => 'users#show'
  get '/profile' => 'users#profile'
  get '/edit' => 'users#edit'
  put '/profile' => 'users#update'
  delete '/profile' => 'users#destroy'

  get '/characters/:name' => 'characters#new'

end
