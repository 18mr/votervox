class Document < ActiveRecord::Base
	scope :unapproved, -> { where("status = 0") }
	scope :approved, -> { where("status = 1") }

	belongs_to :submitter, class_name: "Volunteer"

	validates :name, length: { in: 1..128 }
	validates :language, presence: true
	validates :translated_language, presence: true
	validates :resource_type, presence: true
	validates :location, presence: true

	# Filter functions
	def language_match filter_languages
		filter_languages.include? self.translated_language
	end
	def type_match filter_resource_types
		filter_resource_types.include? self.resource_type
	end
	def location_match filter_location
		self.location == filter_location
	end
	def self.filter languages, resource_type, location
		documents = Document.all
		documents = documents.select{ |d| d.language_match languages } if languages.present?
		documents = documents.select{ |d| d.type_match resource_type } if resource_type.present?
		documents = documents.select{ |d| d.location_match location } if location.present?
		documents || []
	end
end
