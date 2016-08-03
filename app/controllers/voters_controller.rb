class VotersController < ApplicationController
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

	private
		def voter_params
			params.require(:voter).permit(:firstname, :lastname, :communication_mode,
				:contact, :address, :language, :english_comfort, :first_time_voter)
		end

end
