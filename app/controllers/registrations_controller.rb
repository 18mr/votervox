class RegistrationsController < Devise::RegistrationsController
	before_filter :configure_permitted_parameters

	def new
		super
	end

	def create
		super
	end

	def edit
		super
	end

	def update
		super
	end

	protected

		def configure_permitted_parameters
			devise_parameter_sanitizer.permit(:sign_up) do |u|
				u.permit :firstname, :lastname, :email, :phone, :address, :city, :state, :organization_id,
					{:languages => []}, :password, :password_confirmation
			end
			devise_parameter_sanitizer.permit(:account_update) do |u|
				u.permit :firstname, :lastname, :email, :phone, :address, :city, :state, :organization_id,
					{:languages => []}, :password, :password_confirmation, :current_password
			end
		end
end 