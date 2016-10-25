require 'rails_helper'

RSpec.describe Organization, type: :model do
	before(:each) do
	end

	it "can be created with correct fields" do
		expect( FactoryGirl.build(:organization) ).to be_valid
	end

	it "cannot be created without a name" do
		expect( FactoryGirl.build(:organization, :name => "") ).to_not be_valid
	end
end