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
		feedback_data = feedback_sender.merge(:subject => params[:subject], :message => params[:message])
		AdminNotifier.feedback(feedback_data).deliver_now

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
	def default_url_options
	  { locale: I18n.locale }
	end

	# Volunteer sign in/out paths
	def after_sign_in_path_for resource 
		volunteers_home_path
	end

	def after_sign_out_path_for resource 
		new_volunteer_session_path
	end

	# Volunteer/admin authentication
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

	# Voter authentication
	def identify_voter!
		if params[:hashed_id].present?
			cookies[:_vv_hashed_id] = { value: params[:hashed_id], expires: 10.minutes.from_now }
		end
		@voter = cookies[:_vv_hashed_id].present? ? Voter.find_by_hashed_id(cookies[:_vv_hashed_id]) : nil

		# Set locale if specified for voter
		I18n.locale = @voter.locale if @voter.present? && @voter.locale.present?
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

	# Send SMS through Twilio
	def send_sms phone, message
	    account_sid = Rails.application.secrets.twilio_sid
	    auth_token = Rails.application.secrets.twilio_token
	    @client = Twilio::REST::Client.new account_sid, auth_token
	    sms = @client.messages.create(
			from: Rails.application.secrets.twilio_number,
			to: phone,
			body: message
		)
	end

	# Other helper methods
	def full_url path
		['http://', ActionMailer::Base.default_url_options[:host], path].join('')
	end
	def feedback_sender
		if params[:firstname].present? && params[:lastname].present?
			name = [ params[:firstname], params[:lastname] ].join(' ')
			contact = params[:email] || 'Unknown'
		elsif params[:voter_id]
			voter = Voter.find params[:voter_id]
			name = [ voter.firstname, voter.lastname ].join(' ')
			contact = voter.contact
		elsif volunteer_signed_in?
			volunteer = current_record
			name = [ volunteer.firstname, volunteer.lastname ].join(' ')
			contact = voter.email
		else
			name = 'Unknown'
			contact = 'Unknown'
		end
		{:name => name, :contact => contact}
	end
end
