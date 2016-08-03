module VotersHelper
	def chosen_language(language)
	  @voter.languages.nil? ? false : @voter.languages.include?(language)
	end
end
