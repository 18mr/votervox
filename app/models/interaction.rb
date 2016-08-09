class Interaction < ActiveRecord::Base
	scope :proposals, -> { where("contact_type = 0") }
	scope :reschedules, -> { where("contact_type = 1") }
	scope :assistances, -> { where("contact_type = 2") }

	belongs_to :match

	def self.create_proposal parameters
		Interaction.create parameters.merge(:contact_type => 0)
	end
	def self.create_reschedule parameters
		Interaction.create parameters.merge(:contact_type => 1)
	end
	def self.create_assistance parameters
		Interaction.create parameters.merge(:contact_type => 2)
	end
end
