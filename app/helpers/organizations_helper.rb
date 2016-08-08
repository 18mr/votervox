module OrganizationsHelper
	def at_organization_home?
		controller_name == 'organizations' && action_name == 'index'
	end
end
