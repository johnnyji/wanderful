class RegistrationsController < Devise::RegistrationsController
	respond_to :html, :js, :json
end
