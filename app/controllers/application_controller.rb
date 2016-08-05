class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	protected

	def authenticate_admin!
		unless volunteer_signed_in? && current_volunteer.admin?
			redirect_to :new_volunteer_session
		end
	end

	def current_org
		volunteer_signed_in? && current_volunteer.admin? && Volunteer.find(current_volunteer.id).organization
	end

	def matching_volunteer? volunteer
		current_org.nil? || current_org == volunteer.organization
	end
end
