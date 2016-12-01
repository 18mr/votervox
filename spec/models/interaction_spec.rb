require 'rails_helper'

RSpec.describe Interaction, type: :model do
	before(:each) do
	end

	it "can be created with correct fields" do
		expect( FactoryGirl.build(:interaction) ).to be_valid
	end
	it "to propose meeting time with voter sets the contact type to 0" do
		match = FactoryGirl.create(:match)
		interaction = Interaction.create_proposal(:match_id => match.id, :message => "test")
		expect( interaction.contact_type ).to eq 0
	end
	it "to reschedule time with voter sets the contact type to 1" do
		match = FactoryGirl.create(:match)
		interaction = Interaction.create_reschedule(:match_id => match.id, :message => "test")
		expect( interaction.contact_type ).to eq 1
	end
	it "to assist voter sets the contact type to 2" do
		match = FactoryGirl.create(:match)
		interaction = Interaction.create_assistance(:match_id => match.id, :message => "test")
		expect( interaction.contact_type ).to eq 2
	end
end