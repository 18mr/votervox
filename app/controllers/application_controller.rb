class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_action :set_locale
	before_action :identify_voter!, only: [:feedback, :submit_feedback]

	def index
	end

	def feedback
		authenticate_render 'feedback'
	end

	def submit_feedback
		subject = params[:subject]

		# TODO: Send email message to admin with subject and feedback_message

		authenticate_render 'submit_feedback'
	end

	def about
	end

	def privacy_policy
	end

	def terms_of_service
	end

	protected

	def set_locale
		I18n.locale = params[:locale] || I18n.default_locale
	end

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

	def identify_voter!
		if params[:hashed_id].present?
			cookies[:_vv_hashed_id] = { value: params[:hashed_id], expires: 10.minutes.from_now }
		end
		@voter = cookies[:_vv_hashed_id].present? ? Voter.find_by_hashed_id(cookies[:_vv_hashed_id]) : nil
	end

	def authenticate_voter!
		identify_voter!
		if @voter.nil?
			redirect_to :new_voter
		end
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

	def feedback_message
		if params[:firstname].present? && params[:lastname].present?
			message = "Name: params[:firstname] params[:lastname]\n"
			message += "Email: params[:email]\n" if params[:email].present?
			message += "\nparams[:message]"
		elsif params[:voter_id]
			voter = Voter.find params[:voter_id]
			message = "Name: voter.firstname voter.lastname\n"
			message += "Contact: voter.contact\n"
			message += "\nparams[:message]"
		elsif volunteer_signed_in?
			volunteer = current_record
			message = "Name: volunteer.firstname volunteer.lastname\n"
			message += "Email: volunteer.email\n"
			message += "\nparams[:message]"
		else
			message = params[:message]
		end
		message
	end
end
