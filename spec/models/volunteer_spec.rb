require 'rails_helper'

RSpec.describe Volunteer, type: :model do
	before(:each) do
	end

	it "can be created with correct fields" do
		expect( FactoryGirl.build(:volunteer) ).to be_valid
	end

	it "cannot be created if missing name, phone, email, address, or languages" do
		expect( FactoryGirl.build(:volunteer, :firstname => "") ).to_not be_valid
		expect( FactoryGirl.build(:volunteer, :lastname => "") ).to_not be_valid
		expect( FactoryGirl.build(:volunteer, :email => "") ).to_not be_valid
		expect( FactoryGirl.build(:volunteer, :phone => "") ).to_not be_valid
		expect( FactoryGirl.build(:volunteer, :address => "") ).to_not be_valid
		expect( FactoryGirl.build(:volunteer, :languages => []) ).to_not be_valid
	end
	it "cannot be created with invalid first name" do
		expect( FactoryGirl.build(:volunteer, :firstname => "") ).to_not be_valid
	end
	it "cannot be created with invalid last name" do
		expect( FactoryGirl.build(:volunteer, :lastname => "") ).to_not be_valid
	end
	it "cannot be created with invalid phone number" do
		expect( FactoryGirl.build(:volunteer, :phone => "222444") ).to_not be_valid
	end
	it "cannot be created with invalid address" do
		expect( FactoryGirl.build(:volunteer, :address => "1234") ).to_not be_valid
	end
	it "cannot be created without any languages" do
		expect( FactoryGirl.build(:volunteer, :languages => []) ).to_not be_valid
	end
	it "cannot be created if profile image is invalid" do
		file = File.new(Rails.root.join('public', 'robots.txt'))
		expect( FactoryGirl.build(:volunteer, :profile_image => file) ).to_not be_valid
	end
	it "should match volunteer with voter if at least 1 shared language" do
		volunteer = FactoryGirl.create(:matched_volunteer)
		expect( volunteer.language_match volunteer.matches.first ).to be_truthy
		volunteer = FactoryGirl.create(:matched_volunteer, :languages => ["Cambodian"])
		expect( volunteer.language_match volunteer.matches.first ).to be_falsey
	end
	it "calculate distances between voter and volunteer with voter_distance method" do 
		volunteer = FactoryGirl.create(:matched_volunteer)
		voter = volunteer.matches.first.voter
		distance = volunteer.voter_distance( voter )
		expect(distance).to eq 16.29140915359886
	end

	it "calculate match quality based on shared city and/or state" do
		volunteer = FactoryGirl.create(:matched_volunteer)
		voter = volunteer.matches.first.voter
		expect(volunteer.match_quality voter).to eq 1 
		volunteer.update(city: "San Francisco", state: "CA")
		volunteer.save
		expect(volunteer.match_quality voter).to eq 2
		volunteer.update(city: "Washington", state: "DC")
		volunteer.save
		expect(volunteer.match_quality voter).to eq 0
	end

	it "show unmatched voters based on quality threshold" do
		volunteer = FactoryGirl.create(:matched_volunteer)
		voters = FactoryGirl.create_list(:voter,5)
		voter0 = FactoryGirl.create(:voter, :city => "Washington", :state => "DC")
		voter2 = FactoryGirl.create(:voter, :city => "Lafayette", :state => "CA")
		expect( volunteer.match_requests(1).length ).to eq 6
		expect( volunteer.match_requests(2).length ).to eq 1
		expect( volunteer.match_requests(0).length ).to eq 7
	end

	it "sums up total duration of volunteer minutes" do
		volunteer = FactoryGirl.create(:matched_volunteer)
		expect( volunteer.total_duration ).to eq 60
	end

	it "checks on status and admin attribute of volunteer" do
		unapproved_volunteer = FactoryGirl.create(:unapproved_volunteer)
		expect( unapproved_volunteer.unapproved? ).to be_truthy
		approved_volunteer = FactoryGirl.create(:approved_volunteer)
		expect( approved_volunteer.approved? ).to be_truthy
		admin = FactoryGirl.create(:admin)
		expect( admin.admin? ).to be_truthy
	end
end