class ApplicationController < ActionController::Base
	respond_to :html, :js, :json
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def default_serializer_options
    { root: false }
  end

  protected
  def configure_permitted_parameters #adds custom param to devise
  	devise_parameter_sanitizer.for(:sign_up) << :name << :image << :description << :username
  	devise_parameter_sanitizer.for(:account_update) << :name << :image << :description << :username
  end
end 
