class Voter < ActiveRecord::Base

	COMMUNICATION_OPTIONS = [
		['Text Message','sms'],
		['Email','email']
	]

	COMFORT_OPTIONS = [
		['1','1'],
		['2','2'],
		['3','3'],
		['4','4'],
		['5','5']
	]

	validates :firstname, length: { in: 1..128 }
	validates :lastname, length: { in: 1..128 }
	validates :communication_mode, inclusion: { in: COMMUNICATION_OPTIONS.map(&:last) }
	validates :contact, uniqueness: { scope: :communication_mode,
		message: "has been used already. Please visit the homepage link send to you to access your match information." }
	validates :contact, format: { with: /\A\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}z/,
		message: "must be a valid phone number" }, if: :sms_contact?
	validates :contact, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/,
		message: "must be a valid email address" }, if: :email_contact?
	validates :address, length: { in: 5..255 }
	validates :language, length: { in: 1..128 }
	validates :english_comfort, presence: true

	# Accessor functions
	def hashed_id
		(((0x0000FFFF & id)<<16) + ((0xFFFF0000 & id)>>16)).to_s(36)
	end
	def home_url
		['http://', ActionMailer::Base.default_url_options[:host], '/voters/', hashed_id].join('')
	end

	# Helper functions
	def sms_contact?
		communication_mode == 'sms'
	end
	def email_contact?
		communication_mode == 'email'
	end
	def self.communication_options
		COMMUNICATION_OPTIONS
	end
	def self.comfort_options
		COMFORT_OPTIONS
	end
	def self.find_by_hashed_id hashed_id
		voter_id = hashed_id.to_i(36)
		Voter.find( ((0x0000FFFF & voter_id)<<16) + ((0xFFFF0000 & voter_id)>>16) )
	end
end
