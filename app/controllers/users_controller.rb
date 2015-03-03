class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		@posts = Post.all.where(user_id: @user.id).order("created_at DESC")
	end

	def follow
		@user = User.find(params[:id])
		respond_to do |format|
			format.html {
				current_user.follow(@user)
				redirect_to :back
				flash.notice = "You are following @#{@user.username}"
			}
			format.js {
				current_user.follow(@user)
			}
		end
	end

	def unfollow
		@user = User.find(params[:id])
		respond_to do |format|
			format.html {
				current_user.stop_following(@user)
				redirect_to :back
				flash.notice = "You have stopped following @#{@user.username}"
			}
			format.js {
				current_user.stop_following(@user)
			}
		end
	end

	def all_followers
		@user = User.find(params[:id])
		@followers = @user.user_followers
	end

	def all_following
		@user = User.find(params[:id])
		@followings = @user.all_following
	end
end
