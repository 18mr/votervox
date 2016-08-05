module VolunteersHelper
	def organization_name volunteer
		volunteer.organization.nil? ? 'No Organization' : volunteer.organization.name
	end
end
