Rails.application.routes.draw do

  get 'reviews', to: 'reviews#index'

  get 'reviews/:id', to: 'reviews#show'

  post 'reviews', to: 'reviews#create'

  patch 'reviews/:id', to: 'reviews#update'

  delete 'reviews/:id', to: 'reviews#destroy'


  get 'restaurants', to: 'restaurants#index'

  get 'restaurants/:id', to: 'restaurants#show'

  post 'restaurants', to: 'restaurants#create'

  patch 'restaurants/:id', to: 'restaurants#update'

  delete 'restaurants/:id', to: 'restaurants#destroy'

end
