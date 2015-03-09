class CommentsController < ApplicationController
	before_action :authenticate_user!
	before_action :find_post

	def new
		@comment = @post.comments.new(comment_params)
	end

	def create
		@comment = @post.comments.new(comment_params)
		@comment.user_id = current_user.id
		@comment.post_id = @post.id

		respond_to do |format|
			if @comment.save
				format.html {
					flash[:notice] = "Comment created successfully."
					redirect_to post_path(@post)
				}
				format.js
			else
				format.html {
					redirect_to post_path(@post)
					flash.alert = "Comments can't be blank!"
				}
			end
		end
	end

	def delete
		@comment = @post.comments.find(params[:id])
	end

	def destroy
		@comment = @post.comments.find(params[:id])
		respond_to do |format|
			if @comment.destroy
				format.html {
					redirect_to post_path(@comment.post)
					flash.notice = "Comment successfully deleted!"
				}
				format.js
			else
				format.html {
					flash.alert = "Something went wrong... Hmmm"
				}
			end
		end
	end

	# ############################
	# 			PRIVATE METHODS 
	# ############################

	private

	def comment_params
		params.require(:comment).permit(:content)
	end

	def find_post
		@post = Post.find(params[:post_id])
	end
	
end
