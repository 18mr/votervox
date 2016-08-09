module VotersHelper
	def at_voter_home? 
		controller_name == 'voters' && action_name == 'voter_match'
	end

	def at_feedback?
		controller_name == 'application' && action_name == 'feedback' || action_name == 'submit_feedback'
	end

end
