module VotersHelper
	def at_voter_home? 
		controller_name == 'voters' && action_name == 'voter_home'
	end

	def at_feedback?
		controller_name == 'application' && action_name == 'feedback' || action_name == 'submit_feedback'
	end

	def at_voters_list? 
		controller_name == 'voters' && action_name == 'index'
	end
end
