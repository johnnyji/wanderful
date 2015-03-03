class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		@posts = Post.all.where(user_id: @user.id).order("created_at DESC")
	end

	def follow
		@user = User.find(params[:id])
		if current_user
			if current_user == @user
				flash.alert = "You can't follow yourself!"
			else
				current_user.follow(@user)
				redirect_to :back
				#somehow notify the @user that he/she has been followed
				flash.notice = "You are following @#{@user.username}"
			end
		else
			flash.alert = "You must <a href='/users/sign_in'>login</a> in order to follow @#{@user.username}".html_safe
		end
	end

	def unfollow
		@user = User.find(params[:id])
		if current_user
			if current_user == @user
				flash.alert = "You can't unfollow yourself!"
			else
				current_user.stop_following(@user)
				redirect_to :back
				flash.notice = "You have stopped following @#{@user.username}"
			end
		else
			flash.alert = "You must <a href='/users/sign_in'>login</a> in order to follow @#{@user.username}".html_safe
		end
	end
end
