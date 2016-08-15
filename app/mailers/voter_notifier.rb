class VoterNotifier < ApplicationMailer
	def signup_confirmation voter
		@url = full_url voter.home_url
		@firstname = voter.firstname
		subject = t('voter_dashboard.request.message.subject')
		mail(:to => voter.contact, :subject => subject)
	end

	def match_made match
		@url = full_url match.voter.home_url
		@firstname = match.voter.firstname
		@volunteer_name = [match.volunteer.firstname, match.volunteer.lastname].join(' ')
		@message = match.interactions.proposals.first.message
		subject = t('voter_dashboard.matched.message.subject')
		mail(:to => voter.contact, :subject => subject)
	end

	def match_declined match
		@firstname = match.voter.firstname
		subject = t('voter_dashboard.canceled.message.subject')
		mail(:to => voter.contact, :subject => subject)
	end

	def match_completed match
		@url = full_url match.voter.home_url
		@firstname = match.voter.firstname
		subject = t('voter_dashboard.completed.message.subject')
		mail(:to => voter.contact, :subject => subject)
	end
end
