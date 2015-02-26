class PostsController < ApplicationController
	before_action :find_post, only: [:edit, :update, :delete, :destroy, :upvote, :downvote]
	before_action :authenticate_user!, except: [:index, :show] #authenticates user for new/edit/destroy
	respond_to :html, :js

	def index
		@posts = Post.all.order("created_at DESC")
	end

	def show
		@post = Post.find(params[:id])
		@comments = @post.comments
		@random_post = Post.where.not(id: @post).order("RANDOM()").first #generates random posts
		@tags = @post.tags
	end

	def new
		@post = current_user.posts.build #makes sure user_id is present when creating a post
	end

	def create
		@post = current_user.posts.build(post_params)
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
			end
		end
	end

	def edit
	end

	def update
		if @post.update(post_params)
			redirect_to @post
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

	private
	def post_params
		params.require(:post).permit(:title, :link, :description, :image, :bootsy_image_gallery_id, :tag_list)
	end

	def find_post
		@post = Post.find(params[:id])
	end
end
