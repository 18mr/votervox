module ApplicationHelper
	def admin_signed_in?
		volunteer_signed_in? && current_volunteer.admin?
	end
	def super_admin_signed_in?
		admin_signed_in? && Volunteer.find(current_volunteer.id).organization.nil?
	end
	
	def language_options_english
		I18n.available_locales.map{ |lang| [t('locale_name', locale: lang), lang.to_s] }.sort_by(&:first)
	end
	def language_options
		language_options_english.reject{ |l| l.last == 'en' }
	end
	def language_list
		language_options.map(&:first)
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
	def at_documents_index? 
		controller_name == 'documents' && action_name == 'index' || action_name == 'show'
	end
	def at_documents_new? 
		controller_name == 'documents' && action_name == 'new'
	end

	def at_voter_home? 
		controller_name == 'voters' && action_name == 'voter_home'
	end
	def at_feedback?
		controller_name == 'application' && action_name == 'feedback' || action_name == 'submit_feedback'
	end
end
