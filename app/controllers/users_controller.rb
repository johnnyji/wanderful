class UsersController < ApplicationController
	before_action :find_user

	def show
		@posts = Post.all.where(user_id: @user.id).order("created_at DESC")
	end

	def follow
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
		@followers = @user.user_followers
	end

	def all_following
		@followings = @user.all_following
	end

	private
	def find_user
		@user = User.find(params[:id])
	end
end
