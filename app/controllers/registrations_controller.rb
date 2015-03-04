class RegistrationsController < Devise::RegistrationsController
	respond_to :html, :js, :json

	def create
		#write code that will check the user's username validity
		super # runs the rest of the devise registration code
	end

	def update
	end
end
