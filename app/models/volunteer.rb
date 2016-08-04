class Volunteer < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	    :recoverable, :rememberable, :trackable, :validatable

	validates :firstname, length: { in: 1..128 }
	validates :lastname, length: { in: 1..128 }
	validates :phone, format: { with: /\A\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/,
		message: "must be a valid phone number" }
	validates :address, length: { in: 5..255 }
	validates :languages, presence: true

	def unapproved?
		status == 0
	end
	def approved?
		status == 1
	end

end
