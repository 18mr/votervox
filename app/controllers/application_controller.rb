class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def index
	end

	def feedback
		authenticate_render 'feedback'
	end

	def submit_feedback
		subject = params[:subject]
		body = params[:message]

		# Prepare message
		if params[:firstname].present? && params[:lastname].present?
			body = "Name: params[:firstname] params[:lastname]\n"
			body += "Email: params[:email]\n" if params[:email].present?
			body += "\nparams[:message]"
		elsif params[:voter_id]
			voter = Voter.find params[:voter_id]
			body = "Name: voter.firstname voter.lastname\n"
			body += "Contact: voter.contact\n"
			body += "\nparams[:message]"
		elsif volunteer_signed_in?
			volunteer = current_record
			body = "Name: volunteer.firstname volunteer.lastname\n"
			body += "Email: volunteer.email\n"
			body += "\nparams[:message]"
		else
			body = params[:message]
		end

		# TODO: Send email message to admin

		authenticate_render 'submit_feedback'
	end

	protected

	def authenticate_admin!
		unless volunteer_signed_in? && current_volunteer.admin?
			redirect_to :new_volunteer_session
		end
	end

	def current_record
		volunteer_signed_in? && Volunteer.find(current_volunteer.id)
	end

	def current_org
		volunteer_signed_in? && current_record.organization
	end

	def authenticate_render action
		if volunteer_signed_in?
			@user_type = 'volunteer'
			render action, layout: 'volunteer'
		else
			@user_type = 'voter'
			render action, layout: 'voter'
		end
	end
end
