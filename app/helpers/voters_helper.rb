module VotersHelper
	def at_voter_home? 
		controller_name == 'voters' && action_name == 'voter_home'
	end
end
