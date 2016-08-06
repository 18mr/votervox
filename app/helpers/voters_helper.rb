module VotersHelper
	def voter_home? 
		controller_name == 'voters' && current_page?(action: 'voter_home')
	end
end
