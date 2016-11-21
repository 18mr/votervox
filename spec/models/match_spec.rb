require 'rails_helper'

RSpec.describe Match, type: :model do
	before(:each) do
		@match = FactoryGirl.create(:match)
	end

	it "can be created with correct fields" do
		FactoryGirl.build(:match)
	end

	it "creates path to voter_accept_url correctly" do
		expect(@match.voter_accept_url).to eq @match.voter_url 'voter_accept'
	end

	it "creates path to voter_reject_url correctly" do
		expect(@match.voter_reject_url).to eq @match.voter_url 'voter_reject'
	end

	it "creates path to voter_request_time_url correctly" do
		expect(@match.voter_request_time_url).to eq @match.voter_url 'voter_request_time'
	end

	it "creates list of common languages between voter & volunteer" do
		expect(@match.languages).to eq @match.voter.languages & @match.volunteer.languages
	end

	it "checks that match is active" do
		expect(@match.active?).to be_truthy 
	end

	it "specifies if match is proposed or not" do
		expect(@match.proposed?).to be_truthy 
	end

	it "specifies if match is accepted or not" do
		match = FactoryGirl.create(:accepted_match)
		expect(match.accepted?).to be_truthy 
	end

	it "specifies if match is completed or not" do
		match = FactoryGirl.create(:completed)
		expect(match.completed?).to be_truthy 
	end

	it "specifies whether the current volunteer id matches the matches_volunteer" do
		expect(@match.matches_volunteer? @match.volunteer.id).to be_truthy
	end

	it "specifies correct voter id" do
		expect(@match.matches_voter? @match.voter.id).to be_truthy
	end

	it "changes to accepted status" do
		expect(@match.accept!).to eq 1
	end

	it "changes to volunteer_decline status" do
		expect(@match.volunteer_decline!).to eq 2
	end

	it "changes to voter_decline status" do
		expect(@match.voter_decline!).to eq 3
	end
	it "changes to complete status" do
		expect(@match.complete!).to eq 4
	end


end