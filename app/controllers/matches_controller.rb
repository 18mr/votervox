class MatchesController < ApplicationController
	before_filter :authenticate_volunteer!, only: [:index, :create, :message, :decline, :complete, :show]
	layout "volunteer"
	PROPOSAL_INTERACTION = 0
	RESCHEDULE_INTERACTION = 1
	ASSISTANCE_INTERACTION = 2


	### VOLUNTEER ROUTES
	def index
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
		authenticate_volunteer_match!

		if @match.voter.sms_contact?
			# TODO: Send Twilio message to voter with params[:message]
		else
			# TODO: Send email message to voter with params[:message]
		end
		Interaction.create(:match_id => @match.id, :contact_type => PROPOSAL_INTERACTION, :message => params[:message])
		redirect_to @match
	end

	def decline
		@match = Match.find params[:id]
		authenticate_volunteer_match!

		@match.volunteer_decline!
		@match.save
		redirect_to matches_path
	end

	def complete
		@match = Match.find params[:id]
		authenticate_volunteer_match!

		Interaction.create(match_completion_params)
		@match.voter.update(:active => false)
		@match.complete!
		@match.save
		redirect_to matches_path
	end

	def show
		@match = Match.find params[:id]
		authenticate_volunteer_match!

		@proposal = Interaction.where(:match_id => @match.id, :contact_type => PROPOSAL_INTERACTION).first
		@reschedule = Interaction.where(:match_id => @match.id, :contact_type => RESCHEDULE_INTERACTION).first
		@voter = @match.voter
	end


	### VOTER ROUTES
	def voter_match
		@match = Match.find params[:id]
		@voter = Voter.find_by_hashed_id params[:hashed_id]
		authenticate_voter_match!

		@proposal = Interaction.where(:match_id => @match.id, :contact_type => PROPOSAL_INTERACTION).first
		@reschedule = Interaction.where(:match_id => @match.id, :contact_type => RESCHEDULE_INTERACTION).first
		@volunteer = @match.volunteer
	end

	def accept
		@match = Match.find params[:id]
		@voter = Voter.find_by_hashed_id params[:hashed_id]
		authenticate_voter_match!

		@match.accept!
		@match.save
		redirect_to @match.voter_show_url
	end

	def reject
		@match = Match.find params[:id]
		@voter = Voter.find_by_hashed_id params[:hashed_id]
		authenticate_voter_match!

		@match.voter_decline!
		@match.save
		redirect_to @voter.home_url
	end

	def request_time
		@match = Match.find params[:id]
		@voter = Voter.find_by_hashed_id params[:hashed_id]
		authenticate_voter_match!

		# TODO: Send Twilio message to volunteer with params[:message]
		Interaction.create(:match_id => @match.id, :contact_type => RESCHEDULE_INTERACTION, :message => params[:message])
		@match.accept!
		@match.save
		redirect_to @match.voter_show_url
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
			:contact_type => ASSISTANCE_INTERACTION,
			:message => params[:message]
		}
	end


	protected

	def authenticate_volunteer_match!
		unless @match.matches_volunteer? current_volunteer.id
			redirect_to root_path
		end
	end

	def authenticate_voter_match!
		unless @match.matches_voter? @voter.id
			redirect_to root_path
		end
	end

end
