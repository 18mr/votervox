module VolunteersHelper
	def organization_name volunteer
		volunteer.organization.nil? ? 'No Organization' : volunteer.organization.name
	end
	def at_volunteer_list?
		controller_name == 'volunteers' && action_name == 'index'
	end
	def at_volunteer_home?
		controller_name == 'volunteers' && action_name == 'volunteer_home'
	end
	def at_feedback?
		controller_name == 'application' && action_name == 'feedback' || action_name == 'submit_feedback'
	end
end
