module VolunteersHelper
	def organization_name volunteer
		volunteer.organization.nil? ? 'No Organization' : volunteer.organization.name
	end
	def at_volunteer_home?
		controller_name == 'volunteers' && action_name == 'index'
	end
end
