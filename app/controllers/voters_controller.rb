class VotersController < ApplicationController
	before_filter :authenticate_admin!, only: [:index]
	layout :determine_layout

	def index
		@voters = Voter.all
	end

	def new
		@voter = Voter.new
		@communication_options = Voter.communication_options
		@comfort_options = Voter.comfort_options
	end

	def create
		@voter = Voter.new(voter_params)

		if @voter.save
			redirect_to @voter.home_url
		else
			@communication_options = Voter.communication_options
			@comfort_options = Voter.comfort_options
			render 'new'
		end
	end

	def voter_home
		@voter = Voter.find_by_hashed_id params[:hashed_id]
		@match = @voter.matches.active.first
		@completed = @voter.matches.completed.last

		if @match.present?
			@proposal = Interaction.where(:match_id => @match.id, :contact_type => MatchesHelper::PROPOSAL_INTERACTION).first
			@reschedule = Interaction.where(:match_id => @match.id, :contact_type => MatchesHelper::RESCHEDULE_INTERACTION).first
			@volunteer = @match.volunteer
			render 'voter_match'
		elsif @voter.active?
			render 'voter_welcome'
		elsif @completed.present?
			render 'voter_completed'
		else
			render 'voter_cancelled'
		end
	end

	def cancel_request
		@voter = Voter.find_by_hashed_id params[:hashed_id]
		@voter.update(:active => false)
		@voter.matches.active.each do |match|
			match.voter_decline!
			match.save
		end

		redirect_to @voter.home_url
	end

	def activate_request
		@voter = Voter.find_by_hashed_id params[:hashed_id]
		@voter.update(:active => true)

		redirect_to @voter.home_url
	end

	private

	def voter_params
		params.require(:voter).permit(:firstname, :lastname, :communication_mode, :contact,
			:address, :city, :state, {:languages => []}, :english_comfort, :first_time_voter)
	end

	def determine_layout
		return "volunteer" if action_name == "index"
		return "application" if action_name == "new"
		return "voter"
	end

end
