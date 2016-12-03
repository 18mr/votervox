require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

	before(:each) do
	end

	describe "GET #index" do
		it "responds successfully with an HTTP 200 status code" do
			get :index
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the index template" do
			get :index
			expect(response).to render_template("index")
		end
	end

	describe "GET #feedback" do

		it "responds successfully with an HTTP 200 status code" do
			get :feedback
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the feedback template for volunteers" do
			@volunteer = FactoryGirl.create(:volunteer, :email => "test@example.com")
			sign_in @volunteer
			get :feedback
			expect(response).to render_template("feedback")
			expect(response).to render_template("layouts/volunteer")
		end
		it "renders the feedback template for voters" do
			@voter = FactoryGirl.create(:voter)
			@hashed_id = @voter.hashed_id
			get :feedback, :hashed_id => @hashed_id
			expect(response).to render_template("feedback")
			expect(response).to render_template("layouts/voter")
		end
	end

	describe "GET #submit_feedback" do
		it "responds successfully with an HTTP 200 status code" do
			get :submit_feedback
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the submit feedback template for volunteers" do
			@volunteer = FactoryGirl.create(:volunteer, :email => "test@example.com")
			sign_in @volunteer
			get :submit_feedback
			expect(response).to render_template("submit_feedback")
			expect(response).to render_template("layouts/volunteer")
		end
		it "renders the feedback template for voters" do
			@voter = FactoryGirl.create(:voter)
			@hashed_id = @voter.hashed_id
			get :submit_feedback, :hashed_id => @hashed_id
			expect(response).to render_template("submit_feedback")
			expect(response).to render_template("layouts/voter")
		end
	end

	describe "GET #absentee_registration" do
		it "responds successfully with an HTTP 200 status code" do
			get :absentee_registration
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the absentee_registration template for volunteers" do
			@volunteer = FactoryGirl.create(:volunteer, :email => "test@example.com")
			sign_in @volunteer
			get :absentee_registration
			expect(response).to render_template("absentee_registration")
			expect(response).to render_template("layouts/volunteer")
		end
		it "renders the absentee_registration template for voters" do
			@voter = FactoryGirl.create(:voter)
			@hashed_id = @voter.hashed_id
			get :absentee_registration, :hashed_id => @hashed_id
			expect(response).to render_template("absentee_registration")
			expect(response).to render_template("layouts/voter")
		end
	end

	describe "GET #about" do
		it "responds successfully with an HTTP 200 status code" do
			get :about
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the about template" do
			get :about
			expect(response).to render_template("about")
		end
	end

	describe "GET #community_guidelines" do
		it "responds successfully with an HTTP 200 status code" do
			get :community_guidelines
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the community_guidelines template" do
			get :community_guidelines
			expect(response).to render_template("community_guidelines")
		end
	end

	describe "GET #privacy_policy" do
		it "responds successfully with an HTTP 200 status code" do
			get :privacy_policy
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the privacy_policy template" do
			get :privacy_policy
			expect(response).to render_template("privacy_policy")
		end
	end

	describe "GET #terms_of_service" do
		it "responds successfully with an HTTP 200 status code" do
			get :terms_of_service
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the terms_of_service template" do
			get :terms_of_service
			expect(response).to render_template("terms_of_service")
		end
	end

end
