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
	end
end