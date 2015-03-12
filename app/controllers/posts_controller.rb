class PostsController < ApplicationController
	before_action :find_post, only: [:edit, :update, :delete, :destroy, :upvote, :downvote]
	before_action :authenticate_user!, except: [:index, :show, :search]

	def index
		@posts = Post.all.order("created_at DESC")
		# shows posts of current user and their followees
		following_users = current_user.following_users.map(&:id) if current_user
		@posts_by_following = Post.where(user_id: [following_users, current_user.id]).order("created_at DESC") if current_user
	end

	def show
		@post = Post.find(params[:id])
		@random_post = Post.where.not(id: @post).order("RANDOM()").first
		@comments, @tags, @hashtags = ShowPostDependants.call(@post)
	end

	def new
		@post = current_user.posts.build
	end

	def create
		@post = current_user.posts.build(post_params)
		ExtractHashtags.call(@post)
		post_create_status_conditional
	end

	def edit
	end

	def update
		@post.attributes = post_params #sets the post attributes to attributes in form
		UpdateHashtags.call(@post)
    if @post.save(post_params)
      redirect_to @post
      flash.notice = "Post successfully updated!"
    else
      flash.alert = "Something went wrong! Double check please"
      render "edit"
    end
	end 

	def delete
	end

	def destroy
		@post.destroy
		redirect_to root_path
	end

	def upvote
		@post.upvote_by current_user
		respond_to do |format|
			format.html { redirect_to :back }
			format.js
		end
	end

	def downvote
		@post.downvote_by current_user
		respond_to do |format|
			format.html { redirect_to :back }
			format.js
		end
	end

	def search
		@query_name, @search_results = SearchByPrefix.call(params[:query])
		respond_to do |format|
			format.html
			format.js
		end
	end


	# ############################
	# 			PRIVATE METHODS 
	# ############################

	private

	##### POST #####
	def post_params
		params.require(:post).permit(:title, :link, :description, :image, :bootsy_image_gallery_id)
	end

	def find_post
		@post = Post.find(params[:id])
	end

	def post_create_status_conditional
		respond_to do |format|
			if @post.save
				format.html {
					redirect_to @post
					flash.notice = "Succesfully posted!"
				}
				format.js
			else
				format.html {
					flash.alert = @post.errors.full_messages.to_sentence
					render "new"
				}
				format.js
			end
		end
	end
end
