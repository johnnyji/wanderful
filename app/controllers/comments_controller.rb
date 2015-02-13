class CommentsController < ApplicationController
	before_action :authenticate_user!

	def create
		@post = Post.find(params[:post_id])
		@comment = Comment.create(comment_params)
		@comment.user_id = current_user.id
		@comment.post_id = @post.id

		if @comment.save
			redirect_to post_path(@post)
		else
			render "new"
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
