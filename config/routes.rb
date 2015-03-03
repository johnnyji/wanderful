Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: "sessions", registrations: "registrations"}

  resources :users do
    member do
      get :follow
      get :unfollow
    end
  end

  # list of user's followers and followings
  get "users/:id/all_followers" => "users#all_followers", as: "all_followers"
  get "users/:id/all_following" => "users#all_following", as: "all_following"

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
end 
