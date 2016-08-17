class VotersController < ApplicationController
	before_action :authenticate_admin!, only: [:index]
	before_action :authenticate_voter!, only: [:voter_home, :cancel, :activate]
	layout :determine_layout

	def index
		@voters = Voter.all
		@unmatched = Voter.unmatched
		@matched = Voter.matched
		@completed = Voter.completed
	end

	def new
		@voter = Voter.new
		@communication_options = Voter.communication_options
		@comfort_options = Voter.comfort_options
		@client = GooglePlaces::Client.new('AIzaSyAB2Ap-u99P3gRwZFqz3HuonM5_v4v18do')
	end

	def create
		@voter = Voter.new(voter_params)

		if @voter.save
			sms_message = [t('voter_dashboard.request.message.sms'), full_url(@voter.home_url)].join(' ')
			send_sms @voter.contact, sms_message if @voter.sms_contact?
			VoterNotifier.signup_confirmation(@voter).deliver_now if @voter.email_contact?
			redirect_to @voter.home_url
		else
			@communication_options = Voter.communication_options
			@comfort_options = Voter.comfort_options
			render 'new'
		end
	end

	def voter_home
		@match = @voter.active_match || @voter.declined_match
		@completed = @voter.completed_match

		if @match.present?
			@proposal = @match.interactions.proposals.first
			@reschedule = @match.interactions.reschedules.first
			@volunteer = @match.volunteer
			render 'voter_match'
		elsif @voter.active?
			render 'voter_welcome'
		elsif @completed.present?
			@user_type = 'Voter'
			render 'voter_completed'
		else
			render 'voter_cancelled'
		end
	end

	def cancel
		@voter.update(:active => false)
		@voter.matches.active.each do |match|
			send_sms match.volunteer.phone, [match.voter.firstname, t('volunteer_sms.match_rejected'), matches_path].join(' ')
			match.voter_decline!
			match.save
		end

		redirect_to @voter.home_url
	end

	def activate
		@voter.update(:active => true)

		redirect_to @voter.home_url
	end

	private

	def voter_params
		params.require(:voter).permit(:firstname, :lastname, :communication_mode, :contact, :locale,
			:address, :city, :state, :latitude, :longitude, {:languages => []}, :english_comfort, :first_time_voter)
	end

	def determine_layout
		return "volunteer" if action_name == "index"
		return "application" if action_name == "new" || action_name == "create"
		return "voter"
	end

end
