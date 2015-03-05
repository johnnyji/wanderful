class RegistrationsController < Devise::RegistrationsController
	respond_to :html, :js, :json

	def new
		# if !current_user.check_username_format
		# 	redirect_to :back
		# 	flash.notice = "No symbols in usernames!"
		# end
		super
	end

	def create
		super # runs the rest of the devise registration code
	end

	def update
		super
	end
end
