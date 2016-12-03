require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do

	before(:each) do
	end

	describe "GET #new" do
		it "responds successfully with an HTTP 200 status code" do
			@volunteer = FactoryGirl.create(:volunteer, :email => "test@example.com")
			sign_in @volunteer
			get :new
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the index template" do
			@volunteer = FactoryGirl.create(:volunteer, :email => "test@example.com")
			sign_in @volunteer
			get :new
			expect(response).to render_template("new")
		end
	end

	# describe "GET #create" do

	# 	it "responds successfully with an HTTP 200 status code" do
	# 		get :create
	# 		expect(response).to be_success
	# 		expect(response).to have_http_status(200)
	# 	end
	# 	it "renders the new document template for volunteers" do
	# 		@volunteer = FactoryGirl.create(:volunteer, :email => "test@example.com")
	# 		sign_in @volunteer
	# 		get :create
	# 		expect(response).to render_template("new")
	# 		expect(response).to render_template("layouts/volunteer")
	# 	end
	# 	it "renders the feedback template for voters" do
	# 		@voter = FactoryGirl.create(:voter)
	# 		@hashed_id = @voter.hashed_id
	# 		get :create, :hashed_id => @hashed_id
	# 		expect(response).to render_template("new")
	# 		expect(response).to render_template("layouts/voter")
	# 	end
	# end

end
