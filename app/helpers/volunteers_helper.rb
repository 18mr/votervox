module VolunteersHelper
	def organization_name volunteer
		volunteer.organization.nil? ? 'No Organization' : volunteer.organization.name
	end
	def at_volunteer_home?
		controller_name == 'volunteers' && action_name == 'index'
	end
	def at_feedback?
		controller_name == 'application' && action_name == 'feedback' || action_name == 'submit_feedback'
	end
	def at_voters_list? 
		controller_name == 'voters' && action_name == 'index'
	end
end
