# config/routes.rb
Rails.application.routes.draw do
  resources :users

  resources :tasks do
    collection do
      post :bulk_create
      post :bulk_update
      post :bulk_assign
    end
  end

  resources :projects do
    member do
      post 'assign_user'
      put 'change_status'
    end
  end
end
