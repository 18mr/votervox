FactoryGirl.define do
	factory :voter do
		firstname "Tim"
		lastname "Wang"
		communication_mode "Text Message"
		sequence(:contact) { |n| "123-456-789#{n % 10}" }
		address "1 Main Street, San Francisco, CA 94107"
		latitude "37.7806904"
		longitude "-122.38922001"
		languages ['Mandarin','Tagalog']
		english_comfort	true
		active true
		factory :matched_voter do
			status 1
		end
	end
end