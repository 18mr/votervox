FactoryGirl.define do
	factory :match do
		voter
		volunteer
		status 0
		factory :accepted_match do
			status 1
		end
		factory :volunteer_declined do
			status 2
		end
		factory :voter_declined do
			status 3
		end
		factory :completed do
			status 4
		end
		after(:create) do |match,evaluator|
			interaction0 = create(:interaction, :match => match)
			interaction1 = create(:reschedule_contact, :match => match)
			interaction2 = create(:assistant_contact, :match => match)
    	end
	end
end