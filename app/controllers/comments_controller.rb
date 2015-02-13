class CommentsController < ApplicationController
	before_action :authenticate_user!

	def new
		@post = Post.find(params[:post_id])
		@comment = @post.comments.new comment_params
	end

	def create
		@post = Post.find(params[:post_id])
		@comment = @post.comments.new comment_params
		@comment.user_id = current_user.id
		@comment.post_id = @post.id

		if @comment.save
			flash[:notice] = "Comment created successfully."
			redirect_to post_path(@post)
		else
			redirect_to post_path(@post)
			flash.notice = "Comments can't be blank!"
		end
	end

	def destroy
		@post = Post.find(params[:post_id])
		@comment = @post.comments.find(params[:id])
		if @comment.destroy
			redirect_to post_path(@comment.post)
			flash.notice = "Comment successfully deleted!"
		else
			flash.notice = "Something went wrong... Hmmm"
		end
	end

	private
	def comment_params
		params.require(:comment).permit(:content)
	end
	
end
