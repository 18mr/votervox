class Organization < ActiveRecord::Base
	has_many :volunteers
	has_many :matches, through: :volunteers
	has_many :interactions, through: :matches

	validates :name, length: { in: 1..128 }
end
