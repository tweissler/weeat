Rails.application.routes.draw do
  get 'restaurants/list'

  get 'restaurants/retrieve'

  get 'restaurants/create'

  get 'restaurants/update'

  get 'restaurants/delete'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
