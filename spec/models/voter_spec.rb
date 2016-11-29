require 'rails_helper'

RSpec.describe Voter, type: :model do
	before(:each) do
	end

	it "can be created with correct fields" do
		expect( FactoryGirl.build(:voter) ).to be_valid
	end

	it "cannot be created with invalid first name" do
		expect( FactoryGirl.build(:voter, :firstname => "") ).to_not be_valid
	end

	it "cannot be created with invalid last name" do
		expect( FactoryGirl.build(:voter, :lastname => "") ).to_not be_valid
	end
	it "cannot be created with invalid communication mode" do
		expect( FactoryGirl.build(:voter, :communication_mode => "smoke signals") ).to_not be_valid
	end
	it "cannot be created without a unique contact " do
		voter = FactoryGirl.create(:voter, :contact => "123-456-7890")
		expect(FactoryGirl.build(:voter, :contact => "123-456-7890")).to_not be_valid
	end
	it "should format phone number to remove spaces and dashes before validation" do
	    voter = FactoryGirl.create(:voter, :contact => "123-456 7890")
	    expect(voter.contact).to eq "1234567890"
	end

	it "should not accept invalid phone numbers" do
		expect(FactoryGirl.build(:voter, :contact => "%$$!-111--111") ).to_not be_valid
	end

	it "should not accept invalid email address" do
		expect(FactoryGirl.build(:voter, :communication_mode => "Email", :contact => "timchang@") ).to_not be_valid
	end

	it "should not accept invalid address" do
		expect(FactoryGirl.build(:voter, :address => "123") ).to_not be_valid
	end

	it "should not accept without languages present" do
		expect(FactoryGirl.build(:voter, :languages => []) ).to_not be_valid
	end

	it "should not accept without english comfort level present" do
		expect(FactoryGirl.build(:voter, :english_comfort => nil) ).to_not be_valid
	end

	it "should create a hashed_id for voter and valid home URL, and be able to find by hashed id" do
		voter = FactoryGirl.create(:voter)
		id = voter.id
		hashed_id = (((0x0000FFFF & id)<<16) + ((0xFFFF0000 & id)>>16)).to_s(36)
		expect(voter.hashed_id).to eq hashed_id
		expect(voter.home_url).to eq ['/voters/', hashed_id].join('')
		expect( Voter.find_by_hashed_id(hashed_id) ).to eq voter
	end

	it "if matched to volunteer will have an active match status" do
		voter = FactoryGirl.create(:matched_voter)
		expect( voter.active_match.status ).to eq 1
	end

	it "if declined by voter should change to declined by voter match status" do
		voter = FactoryGirl.create(:declined_by_voter)
		expect( voter.declined_match.status ).to eq 3
	end

	it "if completed match voter completed match should change to completed match status" do
		voter = FactoryGirl.create(:completed_match_voter)
		expect( voter.completed_match.status ).to eq 4
	end

	it "calculate distances between voter and volunteer with volunteer_distance method" do 
		voter = FactoryGirl.create(:matched_voter)
		distance = voter.volunteer_distance( voter.active_match.volunteer )
		expect(distance).to eq 16.29140915359886
	end

	it "helper functions work" do
		voter = FactoryGirl.create(:voter)
		expect(voter.active?).to be_truthy
		expect(voter.sms_contact?).to be_truthy
		voter2 = FactoryGirl.create(:voter, :communication_mode => 'Email', :contact => 'example@example.com')
		expect(voter2.email_contact?).to be_truthy
	end

	it "has set options for communciation modes, comfort levels" do
		expect(Voter.communication_options).to eq [["Text Message", "Text Message"], ["Email", "Email"]]
		expect(Voter.comfort_options).to eq [["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"]]
	end

	it "show list of matched voters" do 
		matched_voters = FactoryGirl.create_list(:matched_voter,5)
		expect( Voter.matched.length ).to eq 5
	end

	it "show list of unmatched voters" do
		unmatched_voters = FactoryGirl.create_list(:voter,6)
		expect( Voter.unmatched.length ).to eq 6
	end

	it "show list of completed matches" do
		completed_matches_voters = FactoryGirl.create_list(:completed_match_voter,3)
		expect( Voter.completed.length ).to eq 3
	end


end