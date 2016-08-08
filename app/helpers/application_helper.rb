module ApplicationHelper
	def admin_signed_in?
		volunteer_signed_in? && current_volunteer.admin?
	end
	def super_admin_signed_in?
		admin_signed_in? && Volunteer.find(current_volunteer.id).organization.nil?
	end
	
	def language_list
		['Thai','Vietnamese','Cantonese','Mandarin','Khmer']
	end
	def chosen_language(user,language)
	  user.languages.nil? ? false : user.languages.include?(language)
	end

	def slugify name
		name.gsub(/ /,'_').downcase
	end
	def iso_format date
		date.strftime("%Y-%m-%d")
	end
	def at_voters_list? 
		controller_name == 'voters' && action_name == 'index'
	end
	def at_metrics? 
		controller_name == 'metrics' && action_name == 'index'
	end
	def at_matches? 
		controller_name == 'matches'
	end
	def at_documents? 
		controller_name == 'documents' && action_name == 'index' || action_name == 'new' || action_name == 'show'
	end
	
end
