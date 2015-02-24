class CommentsController < ApplicationController
	before_action :authenticate_user!
	respond_to :html, :js

	def new
		@post = Post.find(params[:post_id])
		@comment = @post.comments.new comment_params
	end

	def create
		@post = Post.find(params[:post_id])
		@comment = @post.comments.new comment_params
		@comment.user_id = current_user.id
		@comment.post_id = @post.id

		respond_to do |format|
			if @comment.save
				format.html {
					flash[:notice] = "Comment created successfully."
					redirect_to post_path(@post)
				}
				format.json
			else
				format.html {
					redirect_to post_path(@post)
					flash.alert = "Comments can't be blank!"
				}
			end
		end
	end

	def destroy
		@post = Post.find(params[:post_id])
		@comment = @post.comments.find(params[:id])
		if @comment.destroy
			redirect_to post_path(@comment.post)
			flash.notice = "Comment successfully deleted!"
		else
			flash.alert = "Something went wrong... Hmmm"
		end
	end

	private
	def comment_params
		params.require(:comment).permit(:content, :bootsy_image_gallery_id)
	end
	
end
