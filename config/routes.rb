Rails.application.routes.draw do

  get 'restaurants', to: 'restaurants#index'

  get 'restaurants/:id', to: 'restaurants#show'

  post 'restaurants', to: 'restaurants#create'

  patch 'restaurants/:id', to: 'restaurants#update'

  delete 'restaurants/:id', to: 'restaurants#destroy'

end
