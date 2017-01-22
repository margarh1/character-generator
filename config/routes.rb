Rails.application.routes.draw do

  root 'users#new'

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

  get '/characters/new' => 'characters#new', as: 'new_character'
  post '/characters' => 'characters#create'
  get '/characters/:name' => 'characters#show', as: 'character'

  get '/reference' => 'sessions#reference'
  get '*path' => 'sessions#nonexistent'

end
