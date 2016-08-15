class MatchesController < ApplicationController
	before_action :authenticate_volunteer!, only: [:index, :create, :message, :decline, :complete, :show]
	before_action :authenticate_voter!, only: [:voter_accept, :voter_reject, :voter_request_time]
	layout "volunteer"

	### VOLUNTEER ROUTES
	def index
		@volunteer = current_record
		@requests = current_record.match_requests
		@accepted = current_record.matches.active
		@completed = current_record.matches.completed
	end

	def create
		@match = Match.new(match_params)

		if @match.save
			if @match.active?
				redirect_to @match
			else
				redirect_to matches_path
			end
		else
			flash[:notice] = 'Unable to accept match with voter.'
			redirect_to matches_path
		end
	end

	def message
		@match = Match.find params[:id]
		redirect_to :voluneers_home if !check_volunteer_match

		Interaction.create_proposal(:match_id => @match.id, :message => params[:message])

		# TODO: Send Twilio message to voter with params[:message]
		VoterNotifier.match_made(@match).deliver_now if @match.voter.email_contact?
		redirect_to @match
	end

	def decline
		@match = Match.find params[:id]
		redirect_to :voluneers_home if !check_volunteer_match

		# TODO: Send SMS message to voter about decline
		VoterNotifier.match_declined(@match).deliver_now if @match.voter.email_contact?
		@match.volunteer_decline!
		@match.save
		redirect_to matches_path
	end

	def complete
		@match = Match.find params[:id]
		redirect_to :voluneers_home if !check_volunteer_match

		Interaction.create_assistance(match_completion_params)
		
		# TODO: Send SMS message to voter about completion
		VoterNotifier.match_completed(@match).deliver_now if @match.voter.email_contact?
		@match.voter.update(:active => false)
		@match.complete!
		@match.save
		redirect_to matches_path
	end

	def show
		@match = Match.find params[:id]
		redirect_to :volunteers_home if !check_volunteer_match

		@proposal = @match.interactions.proposals.first
		@reschedule = @match.interactions.reschedules.first
		@voter = @match.voter
	end


	### VOTER ROUTES
	def voter_accept
		@match = Match.find params[:id]
		redirect_to :new_voter if !check_voter_match

		# TODO: Send SMS and email to volunteer about acceptance
		@match.accept!
		@match.save
		redirect_to @voter.home_url
	end

	def voter_reject
		@match = Match.find params[:id]
		redirect_to :new_voter if !check_voter_match

		# TODO: Send SMS and email to volunteer about rejection
		@match.voter_decline!
		@match.save
		redirect_to @voter.home_url
	end

	def voter_request_time
		@match = Match.find params[:id]
		redirect_to :new_voter if !check_voter_match

		# TODO: Send Twilio message to volunteer with params[:message]
		Interaction.create_reschedule(:match_id => @match.id, :message => params[:message])
		@match.accept!
		@match.save
		redirect_to @voter.home_url
	end


	private

	def match_params
		params.require(:match).permit(:voter_id, :status).merge(:volunteer_id => current_volunteer.id)
	end
	def match_completion_params
		duration_data = params[:duration].split(':')
		duration = 60 * duration_data[0].to_i + duration_data[1].to_i rescue nil
		{
			:match_id => params[:id],
			:duration => duration,
			:message => params[:message]
		}
	end


	protected

	def check_volunteer_match
		@match.matches_volunteer? current_volunteer.id
	end

	def check_voter_match
		@match.matches_voter? @voter.id
	end

end
