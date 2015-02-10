Rails.application.routes.draw do
  devise_for :users

  resources :posts do #nested routes, comments only visible through posts
  	resources :comments
  end

  root "posts#index"
end
