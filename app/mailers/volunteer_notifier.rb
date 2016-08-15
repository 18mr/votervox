class VolunteerNotifier < ApplicationMailer
	def signup_confirmation volunteer
		@url = full_url '/volunteers/home'
		@firstname = volunteer.firstname
		mail(:to => volunteer.email, :subject => "Welcome to VoterVOX!")
	end

	def match_accepted match
		@firstname = match.volunteer.firstname
		@voter_name = match.voter.firstname
		@voter_contact = match.voter.contact
		mail(:to => volunteer.email, :subject => "#{@voter_name} has accepted your suggested time")
	end

	def match_time_change match
		@firstname = match.volunteer.firstname
		@voter_name = match.voter.firstname
		@voter_contact = match.voter.contact
		@message = match.interactions.reschedules.first.message
		mail(:to => volunteer.email, :subject => "#{@voter_name} has requested a different time")
	end

	def match_rejected match
		@url = full_url '/matches'
		@firstname = match.volunteer.firstname
		@voter_name = match.voter.firstname
		mail(:to => volunteer.email, :subject => "#{@voter_name} has declined translation assistance")
	end
end
