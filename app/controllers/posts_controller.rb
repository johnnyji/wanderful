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
		show_post_dependants
	end

	def new
		@post = current_user.posts.build
	end

	def create
		@post = current_user.posts.build(post_params)
		create_and_extract_tags
		post_create_status_conditional
	end

	def edit
	end

	def update
		@post.attributes = post_params #sets the post attributes to attributes in form
		update_and_extract_tags
		post_update_status_conditional
	end 

	def delete
	end

	def destroy
		@post.destroy
		redirect_to root_path
	end

	def upvote
		@post.upvote_by current_user
		voting_ajax_call
	end

	def downvote
		@post.downvote_by current_user
		voting_ajax_call
	end

	def search
		respond_to do |format|
			format.html { search_query_conditional }
			format.js { search_query_conditional }
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

	def show_post_dependants
		@comments = @post.comments.order("created_at DESC")
		@tags = @post.tags
		@hashtags = @post.extract_tags
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

	def post_update_status_conditional
		if @post.save(post_params)
			redirect_to @post
			flash.notice = "Post successfully updated!"
		else
			flash.alert = "Something went wrong! Double check please"
			render "edit"
		end
	end

	##### AJAX CALL FOR LIKES & DISLIKES #####
	def voting_ajax_call
		respond_to do |format|
			format.html { redirect_to :back }
			format.js
		end
	end

	##### EXTRACTING HASHTAGS #####
	def create_and_extract_tags
		tags = @post.extract_tags
		tags.each { |tag| @post.tag_list.add(tag) }
	end

	def update_and_extract_tags
		current_tags = @post.tag_list
		current_tags.remove(current_tags) # clears the tag list
		tags = @post.extract_tags # extracts tags from the edit view description set by the @post.attributes
		tags.each { |tag| @post.tag_list.add(tag) } # adds each tag to the tag list
	end

	##### SEARCH QUERY #####
	def search_query_conditional
		@query = params[:query]
		if @query.start_with? "#"
			search_posts_by_hashtag
		elsif @query.start_with? "@"
			search_posts_by_user
		else
			search_posts_by_name
		end
	end

	def search_posts_by_hashtag
		@query.slice!(0)
		@search_results = Post.tagged_with(@query).order("created_at DESC")
		@query_name = "<span class='query-name'>##{@query}</span>".html_safe
	end

	def search_posts_by_user
		@query.slice!(0)
		post_user = User.find_by(username: @query)

		if post_user #makes sure that the user exists in the database
			@search_results = Post.all.where(user_id: post_user.id).order("created_at DESC")
		else
			@search_results = ""
		end
		@query_name = "Posts by <span class='query-name'>@#{@query}</span>".html_safe
	end

	def search_posts_by_name
		@search_results = Post.search(@query).order("created_at DESC")
		@query_name = "Posts about <span class='query-name'>#{@query}</span>".html_safe
	end
end
