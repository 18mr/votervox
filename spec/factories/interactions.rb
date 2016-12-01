FactoryGirl.define do
	factory :interaction do
		duration 10
		match
		contact_type 0
		message "test"
		factory :reschedule_contact do
			contact_type 1
			duration 20
		end
		factory :assistant_contact do
			contact_type 2
			duration 30
		end
	end
end