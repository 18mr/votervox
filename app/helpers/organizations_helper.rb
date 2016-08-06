module OrganizationsHelper
	def organization_home? 
		controller_name == 'organizations' && current_page?(action: 'index')
	end
end
