class Match < ActiveRecord::Base
	scope :active, -> { where("status in (0,1)") }
	scope :declined, -> { where("status in (2,3)") }
	scope :proposed, -> { where("status = 0") }
	scope :accepted, -> { where("status = 1") }
	scope :volunteer_declined, -> { where("status = 2") }
	scope :voter_declined, -> { where("status = 3") }
	scope :completed, -> { where("status = 4") }

	belongs_to :voter
	belongs_to :volunteer
	has_many :interactions

	# Accessor functions
	def voter_url method
		['/matches/', self.id, '/', method, '/', self.voter.hashed_id].join('')
	end
	def voter_show_url
		voter_url 'show'
	end
	def voter_accept_url
		voter_url 'accept'
	end
	def voter_reject_url
		voter_url 'reject'
	end
	def voter_request_time_url
		voter_url 'request_time'
	end

	# Helper functions
	def active?
		status == 0 || status == 1
	end
	def proposed?
		status == 0
	end
	def accepted?
		status == 1
	end
	def completed?
		status == 4
	end
	def matches_volunteer? volunteer_id
		self.volunteer_id == volunteer_id
	end
	def matches_voter? volunteer_id
		self.voter_id == volunteer_id
	end

	# Status update functions
	def accept!
		self.status = 1
	end
	def volunteer_decline!
		self.status = 2
	end
	def voter_decline!
		self.status = 3
	end
	def complete!
		self.status = 4
	end
end
