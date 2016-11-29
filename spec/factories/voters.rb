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
			after(:create) do |voter, evaluator|
				volunteer = create(:volunteer, :address => "3601 Deer Hill Road, Lafayette, CA 94549",
									:latitude => "37.89318", :longitude => "-122.1268296")
                match = create(:match, volunteer: volunteer, voter: voter, status: 1 )
			end
		end
		factory :declined_by_voter do
			after(:create) do |voter, evaluator|
				volunteer = create(:volunteer)
                match = create(:match, volunteer: volunteer, voter: voter, status: 3 )
			end
		end
		factory :completed_match_voter do
			after(:create) do |voter, evaluator|
				volunteer = create(:volunteer)
                match = create(:match, volunteer: volunteer, voter: voter, status: 4 )
                voter.update(active: false)
			end
		end
	end
end