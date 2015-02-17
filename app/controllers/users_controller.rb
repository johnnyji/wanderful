class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		@posts = Post.all.where(user: @user).order("created_at DESC")
	end
end
