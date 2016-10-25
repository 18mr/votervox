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

	it "cannot be created if profile image is invalid" do
		file = File.new(Rails.root.join('public', 'robots.txt'))
		expect( FactoryGirl.build(:volunteer, :profile_image => file) ).to_not be_valid
	end
end