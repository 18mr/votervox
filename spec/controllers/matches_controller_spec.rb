require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
	before(:all) do
		@match_params = FactoryGirl.attributes_for(:match)
	end

	before(:each) do
		@volunteer = FactoryGirl.create(:volunteer)
		sign_in @volunteer
	end

	describe "GET #index" do
		it "responds successfully with an HTTP 200 status code" do
			get :index
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the index template if format html" do
			get :index
			expect(response).to render_template("index")
			expect(response).to render_template("layouts/volunteer")
		end
		it "assigns correct variables for the view" do
			@voters = FactoryGirl.create_list(:voter, 3)
			requested_match = FactoryGirl.create(:match, voter: @voters[0], volunteer: @volunteer)
			accepted_match = FactoryGirl.create(:accepted_match, voter: @voters[1], volunteer: @volunteer)
			completed_match = FactoryGirl.create(:completed, voter: @voters[2], volunteer: @volunteer)
			get :index
			expect( assigns(:volunteer) ).to eq(@volunteer)
			expect( assigns(:requests) ).to eq( @volunteer.match_requests )
			expect( assigns(:accepted) ).to eq( @volunteer.matches.active )
			expect( assigns(:completed) ).to eq( @volunteer.matches.completed )
		end
	end
	describe "POST #create" do
		it "responds successfully with an HTTP 302 status code" do
			post :create, { match: @match_params }
			expect(response).to have_http_status(302)
		end
		it "creates match" do
			expect { post :create, :match => @match_params }.to change(Match, :count).by(1) 
		end
		#can't figure out how to do a redirect to @match or how to test when match isn't active
	end

	describe "POST #message" do
		before(:each) do
			@votervoxsms = double(:votervoxsms)
			@voternotifier = double(:voternotifier)
			@match = FactoryGirl.create(:match)
		end
		it "successful votervox sms message redirects to match path" do
			allow(VoterVoxSms).to receive(:new).and_return(@votervoxsms)
			allow(@votervoxsms).to receive(:send)
			post :message, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/volunteers/home?locale=en" )
		end

		it "successful voternotifier message redirects to match path" do
			allow(VoterNotifier).to receive(:match_made).and_return(@voternotifier)
			@match.voter.communication_mode = "Email"
			@match.voter.contact = "test@example.com"
			post :message, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/volunteers/home?locale=en" )
		end
	end
	
	describe "GET #decline" do
		before(:each) do
			@votervoxsms = double(:votervoxsms)
			@voternotifier = double(:voternotifier)
			@match = FactoryGirl.create(:match)
		end
		it "successful votervox sms message redirects to match path" do
			allow(VoterVoxSms).to receive(:new).and_return(@votervoxsms)
			allow(@votervoxsms).to receive(:send)
			get :decline, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/volunteers/home?locale=en" )
		end

		it "successful voternotifier message redirects to match path" do
			allow(VoterNotifier).to receive(:match_declined).and_return(@voternotifier)
			@match.voter.communication_mode = "Email"
			@match.voter.contact = "test@example.com"
			get :decline, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/volunteers/home?locale=en" )
		end
	end
	describe "POST #complete" do
		before(:each) do
			@votervoxsms = double(:votervoxsms)
			@voternotifier = double(:voternotifier)
			@match = FactoryGirl.create(:match)
		end
		it "successful votervox sms message redirects to match path" do
			allow(VoterVoxSms).to receive(:new).and_return(@votervoxsms)
			allow(@votervoxsms).to receive(:send)
			post :complete, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/volunteers/home?locale=en" )
		end

		it "successful voternotifier message redirects to match path" do
			allow(VoterNotifier).to receive(:match_completed).and_return(@voternotifier)
			@match.voter.communication_mode = "Email"
			@match.voter.contact = "test@example.com"
			post :complete, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/volunteers/home?locale=en" )
		end
	end
	describe "GET #show" do
		before(:each) do
			@match = FactoryGirl.create(:match)
		end
		it "responds successfully with an HTTP 302 status code" do
			get :show, :id => @match.id
			expect(response).to have_http_status(302)
		end
		it "redirect to volunteers home" do
			get :show, :id => @match.id
			expect(response).to redirect_to( "/volunteers/home?locale=en" )
		end
		it "assigns correct variables for the view" do
			@proposal = @match.interactions.proposals.first
			@reschedule = @match.interactions.reschedules.first
			@voter = @match.voter
			get :show, :id => @match.id
			expect( assigns(:proposal) ).to eq(@proposal)
			expect( assigns(:reschedule) ).to eq( @reschedule )
			expect( assigns(:voter) ).to eq( @voter )
		end
	end
	describe "GET #voter_accept" do
		before(:each) do
			@votervoxsms = double(:votervoxsms)
			@volunteernotifier = double(:volunteernotifier)
			@match = FactoryGirl.create(:match)
		end
		it "successful votervox sms message redirects to match path" do
			allow(VoterVoxSms).to receive(:new).and_return(@votervoxsms)
			allow(@votervoxsms).to receive(:send)
			get :voter_accept, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/voters/new?locale=en" )
		end

		it "successful voternotifier message redirects to match path" do
			allow(VolunteerNotifier).to receive(:match_accepted).and_return(@voternotifier)
			@match.voter.communication_mode = "Email"
			@match.voter.contact = "test@example.com"
			get :voter_accept, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/voters/new?locale=en" )
		end
	end

	describe "GET #voter_reject" do
		before(:each) do
			@votervoxsms = double(:votervoxsms)
			@volunteernotifier = double(:volunteernotifier)
			@match = FactoryGirl.create(:match)
		end
		it "successful votervox sms message redirects to match path" do
			allow(VoterVoxSms).to receive(:new).and_return(@votervoxsms)
			allow(@votervoxsms).to receive(:send)
			get :voter_reject, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/voters/new?locale=en" )
		end
		it "successful voternotifier message redirects to match path" do
			allow(VolunteerNotifier).to receive(:match_rejected).and_return(@voternotifier)
			@match.voter.communication_mode = "Email"
			@match.voter.contact = "test@example.com"
			get :voter_reject, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/voters/new?locale=en" )
		end
	end
	describe "POST #voter_request_time" do
		before(:each) do
			@votervoxsms = double(:votervoxsms)
			@volunteernotifier = double(:volunteernotifier)
			@match = FactoryGirl.create(:match)
		end
		it "successful votervox sms message redirects to match path" do
			allow(VoterVoxSms).to receive(:new).and_return(@votervoxsms)
			allow(@votervoxsms).to receive(:send)
			post :voter_request_time, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/voters/new?locale=en" )
		end
		it "successful voternotifier message redirects to match path" do
			allow(VolunteerNotifier).to receive(:match_time_change).and_return(@voternotifier)
			@match.voter.communication_mode = "Email"
			@match.voter.contact = "test@example.com"
			post :voter_request_time, :id => @match.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( "/voters/new?locale=en" )
		end
	end
end
