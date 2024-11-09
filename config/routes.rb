Rails.application.routes.draw do
  resources :users, only: [:create, :update, :destroy, :index, :show]
  resources :tasks, only: [:create, :update, :destroy, :index, :show]
  resources :projects, only: [:create, :update, :destroy, :index, :show]
end
