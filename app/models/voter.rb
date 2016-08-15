class Voter < ActiveRecord::Base
	scope :active, -> { where("active = true") }
	scope :inactive, -> { where("active = false") }

	has_many :matches

	COMMUNICATION_MODES = ['Text Message','Email']
	COMFORT_LEVEL = ['Not comfortable','Slightly comfortable','Comfortable','Very comfortable']

	before_validation :format_phone

	def format_phone
		return unless sms_contact?
		phone_regex = /\A\(?(\d{3})\)?[\s.-]?(\d{3})[\s.-]?(\d{4})\z/
		re_match = self.contact.match(phone_regex)
		return if re_match.nil?
		self.contact = re_match[1] + re_match[2] + re_match[3]
	end

	validates :firstname, length: { in: 1..128 }
	validates :lastname, length: { in: 1..128 }
	validates :communication_mode, inclusion: { in: COMMUNICATION_MODES }
	validates :contact, uniqueness: { scope: :communication_mode,
		message: "has been used already. Please visit the homepage link send to you to access your match information." }
	validates :contact, format: { with: /\A\d{10}\z/,
		message: "must be a valid phone number" }, if: :sms_contact?
	validates :contact, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/,
		message: "must be a valid email address" }, if: :email_contact?
	validates :address, length: { in: 5..255 }
	validates :languages, presence: true
	validates :english_comfort, presence: true

	# Accessor functions
	def hashed_id
		(((0x0000FFFF & id)<<16) + ((0xFFFF0000 & id)>>16)).to_s(36)
	end
	def home_url
		['/voters/', hashed_id].join('')
	end
	def active_match
		self.matches.active.first
	end
	def completed_match
		self.matches.completed.last
	end

	# Volunteer Match Functions
	def volunteer_distance volunteer
		Geocoder::Calculations.distance_between [self.latitude, self.longitude], [voter.latitude, voter.longitude] rescue nil
	end

	# Helper functions
	def active?
		active
	end
	def sms_contact?
		communication_mode == 'Text Message'
	end
	def email_contact?
		communication_mode == 'Email'
	end
	def self.communication_options
		COMMUNICATION_MODES.zip(COMMUNICATION_MODES)
	end
	def self.comfort_options
		COMFORT_LEVEL.zip(COMFORT_LEVEL)
	end
	def self.find_by_hashed_id hashed_id
		voter_id = hashed_id.to_i(36)
		Voter.find( ((0x0000FFFF & voter_id)<<16) + ((0xFFFF0000 & voter_id)>>16) ) rescue nil
	end
	def self.matched
		Voter.includes(:matches).active.select{ |v| v.matches.active.present? }
	end
	def self.unmatched
		Voter.includes(:matches).active.select{ |v| v.matches.active.empty? }
	end
	def self.completed
		Voter.includes(:matches).inactive.select{ |v| v.matches.completed.present? }
	end
end
