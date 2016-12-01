FactoryGirl.define do
	factory :volunteer do
		firstname "Jane"
		lastname "Cho"
		sequence(:email) { |n| "jcho#{n}@example.com" }
		sequence(:phone) { |n| "123-456-789#{n % 10}" }
		address "3601 Deer Hill Road, Lafayette, CA 94549"
		city "Lafayette"
		state "CA"
		latitude "37.89318"
		longitude "-122.1268296"
		organization
		languages ['Mandarin','Hindi','Spanish']
		profile_image { File.new(Rails.root.join('app', 'assets', 'images', 'volunteer.png')) }
		password "mypassword"
		password_confirmation "mypassword"
		status 0
		admin false

		factory :approved_volunteer do
			status 1
		end
		factory :matched_volunteer do
			status 1
			after(:create) do |volunteer, evaluator|
				voter = create(:voter, :languages => ["Mandarin", "Hindi"])
                match = create(:match, volunteer: volunteer, voter: voter, status: 3 )
    			interaction0 = create(:interaction, :match => match)
    			interaction1 = create(:reschedule_contact, :match => match)
    			interaction2 = create(:assistant_contact, :match => match)
			end
		end
		factory :banned_volunteer do
			status 2
		end
		factory :unapproved_volunteer do
			status 0
		end
		factory :admin do
			status 1
			admin true
		end
	end
end