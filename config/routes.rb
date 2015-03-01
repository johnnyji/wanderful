Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: "sessions", registrations: "registrations"}
  resources :users
  resources :tags
  resources :posts do #nested routes, comments only visible through posts
  	member do
  		get "like", to: "posts#upvote"
  		get "dislike", to: "posts#downvote"
  	end
  	resources :comments
  end

  root "posts#index"

  # search path
  get '/search' => 'posts#search'
  # get '/tag_search' => 'posts#tag_search'
end 
