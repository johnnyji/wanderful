class UsersController < ApplicationController
	before_action :find_user

	def show
		@posts = Post.all.where(user_id: @user.id).order("created_at DESC")
	end

	def follow
		follow_user_ajax
	end

	def unfollow
		unfollow_user_ajax
	end

	def all_followers
		@followers = @user.user_followers.order('name')
	end

	def all_following
		@followings = @user.following_by_type('User').order('name')
	end


	# ############################
	# 			PRIVATE METHODS 
	# ############################

	private

	def find_user
		@user = User.find(params[:id])
	end

	def follow_user_ajax
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

	def unfollow_user_ajax
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
end
