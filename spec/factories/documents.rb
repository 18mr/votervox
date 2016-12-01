FactoryGirl.define do
	factory :document do
		name "Know Your Voting Rights"
		language "English"
		translated_language "Cantonese"
		resource_type "know your voting rights"
		location "United States"
		file { File.new(Rails.root.join('app', 'assets', 'images', 'KYVR_Chinese.pdf')) }
	end
end