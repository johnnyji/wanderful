Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: "sessions", registrations: "registrations"}

  resources :users do
    member do
      get :follow
      get :unfollow
    end
  end

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
