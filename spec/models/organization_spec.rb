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

	it "cannot be created with invalid name" do
		expect( FactoryGirl.build(:organization, :name => "Coloring book whatever you probably haven't heard of them nihil next level. Celiac polaroid anim fanny pack. Pickled post-ironic before they sold out twee retro biodiesel.") ).to_not be_valid
	end
end