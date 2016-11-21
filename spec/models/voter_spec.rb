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
		voter1 = FactoryGirl.create(:voter, :contact => "123-456-7890")
		expect(FactoryGirl.build(:voter, :contact => "123-456-7890")).to_not be_valid
	end
end