require 'rails_helper'

RSpec.describe Document, type: :model do
	before(:each) do
	end
	#paperclip tests http://www.rubydoc.info/gems/paperclip/Paperclip/Shoulda/Matchers
	it { should have_attached_file(:file) }
	  it { should validate_attachment_presence(:file) }
	  it { should validate_attachment_content_type(:file).
	                allowing('application/pdf', 'application/msword').
	                rejecting('text/plain', 'text/xml', 'image/png', 'image/gif') }
	  it { should validate_attachment_size(:file).
	                less_than(5.megabytes) }

	it "can be created with correct fields" do
		expect( FactoryGirl.build(:document) ).to be_valid
	end

	it "cannot be created with invalid name language, translated language, resource_type, location & file" do
		expect( FactoryGirl.build(:document, :name => "") ).to_not be_valid
		expect( FactoryGirl.build(:document, language: "") ).to_not be_valid
		expect( FactoryGirl.build(:document, translated_language: "") ).to_not be_valid
		expect( FactoryGirl.build(:document, resource_type: "") ).to_not be_valid
		expect( FactoryGirl.build(:document, location: "") ).to_not be_valid
		expect( FactoryGirl.build(:document, file: nil) ).to_not be_valid
	end

	it "should filter by selected languages, type and location_match" do
		document = FactoryGirl.create(:document)
		document2 = FactoryGirl.create(:document, :translated_language => "Hindi")
		document3 = FactoryGirl.create(:document, :resource_type => "ballot")
		expect(document.language_match ["Cantonese"]).to be_truthy
		expect(document.type_match "know your voting rights").to be_truthy
		expect(document.location_match "United States").to be_truthy
		expect( Document.filter ["Cantonese"],"know your voting rights","United States" ).to eq [document]
	end
end