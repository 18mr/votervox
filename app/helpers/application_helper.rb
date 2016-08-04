module ApplicationHelper
	def language_list
		['Thai','Vietnamese','Cantonese','Mandarin','Khmer']
	end
	def chosen_language(user,language)
	  user.languages.nil? ? false : user.languages.include?(language)
	end
end
