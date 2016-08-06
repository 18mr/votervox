module VolunteersHelper
	def organization_name volunteer
		volunteer.organization.nil? ? 'No Organization' : volunteer.organization.name
	end
	def volunteer_home? 
		controller_name == 'volunteers' && current_page?(action: 'index')
	end
end
