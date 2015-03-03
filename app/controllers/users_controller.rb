class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		@posts = Post.all.where(user_id: @user.id).order("created_at DESC")
	end

	def follow
		@user = User.find(params[:id])
			current_user.follow(@user)
			redirect_to :back
			#somehow notify the @user that he/she has been followed
			flash.notice = "You are following @#{@user.username}"
	end

	def unfollow
		@user = User.find(params[:id])
			current_user.stop_following(@user)
			redirect_to :back
			flash.notice = "You have stopped following @#{@user.username}"
	end
end
