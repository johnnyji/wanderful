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
		respond_to do |format|
			format.html
			format.json { render json: @post }
		end
	end

	def new
		@post = current_user.posts.build
	end

	def create
		@post = current_user.posts.build(post_params)
		ExtractHashtags.call(@post)
		respond_to do |format|
			if @post.save
				embed_hashtags(@post)
				format.html { redirect_to @post, notice: 'Succesfully posted!' }
				format.js
			else
				format.html { render 'new' }
				format.js { render 'createError.js.erb' } #make this create file
			end
		end
	end

	def edit
	end

	def update
		@post.attributes = post_params #sets the post attributes to attributes in form
		ExtractHashtags.call(@post)
    if @post.save(post_params)
    	embed_hashtags(@post)
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
		params.require(:post).permit(:title, :link, :description, :image, :bootsy_image_gallery_id, :tag_list)
	end

	def find_post
		@post = Post.find(params[:id])
	end

	def embed_hashtags(post)
		body = post.description
    post.reload.tags.each do |hashtag|
      body.gsub!("##{hashtag.name}", view_context.link_to("##{hashtag.name}", tag_path(hashtag.id)))
    end
    post.update(description: body)
  end
end
