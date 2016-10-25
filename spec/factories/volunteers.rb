FactoryGirl.define do
	factory :volunteer do
		firstname "Jane"
		lastname "Cho"
		sequence(:email) { |n| "jcho#{n}@example.com" }
		sequence(:phone) { |n| "123-456-789#{n % 10}" }
		address "123 Main Street, San Francisco, CA 94107"
		latitude "37.7806904"
		longitude "-122.38922001"
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
		factory :banned_volunteer do
			status 2
		end
		factory :admin do
			status 1
			admin true
		end
	end
end