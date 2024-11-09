# config/routes.rb
Rails.application.routes.draw do
  resources :users
  resources :tasks
  resources :projects
end
