Rails.application.routes.draw do
  devise_for :users

  resources :posts do #nested routes, comments only visible through posts
  	member do
  		get "like", to: "posts#upvote"
  		get "dislike", to: "posts#downvote"
  	end
  	resources :comments
  end

  root "posts#index"
end
