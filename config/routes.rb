Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :restaurants do
    collection do
      get :load
    end
  end

  resources :restaurants, except: [:edit, :new] do
    resources :reviews, except: [:edit, :new]
  end
  root 'application#index'

end
