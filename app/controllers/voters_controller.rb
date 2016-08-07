class VotersController < ApplicationController
	before_filter :authenticate_admin!, only: [:index]
	layout "voter", :except => :new

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
	end

	def cancel_request
		@voter = Voter.find_by_hashed_id params[:hashed_id]
		@voter.update(:active => false)
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

end
