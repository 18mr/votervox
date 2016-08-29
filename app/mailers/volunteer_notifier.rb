class VolunteerNotifier < ApplicationMailer
	def signup_confirmation volunteer
		@url = volunteers_url
		@firstname = volunteer.firstname
		mail(:to => volunteer.email, :subject => "Welcome to VoterVOX!")
	end

	def match_accepted match
		@firstname = match.volunteer.firstname
		@voter_name = match.voter.firstname
		@voter_contact = match.voter.contact
		mail(:to => match.volunteer.email, :subject => "#{@voter_name} has accepted your suggested time")
	end

	def match_time_change match
		@firstname = match.volunteer.firstname
		@voter_name = match.voter.firstname
		@voter_contact = match.voter.contact
		@message = match.interactions.reschedules.first.message
		mail(:to => match.volunteer.email, :subject => "#{@voter_name} has requested a different time")
	end

	def match_rejected match
		@url = matches_url
		@firstname = match.volunteer.firstname
		@voter_name = match.voter.firstname
		mail(:to => match.volunteer.email, :subject => "#{@voter_name} has declined translation assistance")
	end

	def new_matches volunteer, voters
		@url = matches_url
		@voters = voters
		@firstname = volunteer.firstname
		mail(:to => volunteer.email, :subject => "New voter matches near you")
	end

	def completion_check volunteer, match
		@url = match_url(match)
		@voter = match.voter
		@firstname = volunteer.firstname
		mail(:to => volunteer.email, :subject => "Is your translation match complete?")
	end
end
