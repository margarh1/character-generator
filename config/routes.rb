Rails.application.routes.draw do

  root 'sessions#root'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/profile' => 'users#profile'
  get '/edit' => 'users#edit'
  put '/profile' => 'users#update'
  patch '/profile' => 'users#update'
  delete '/profile' => 'users#destroy'

  get '/characters/new' => 'characters#new', as: 'new_character'
  get '/characters/new/random' => 'characters#generate', as: 'generate_character'
  post '/characters' => 'characters#create'
  delete '/characters/:name' => 'characters#destroy'

  get '/reference/:title' => 'sessions#reference'
  get '*path' => 'sessions#nonexistent'

end
