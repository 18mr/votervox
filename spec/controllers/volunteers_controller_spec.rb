require 'rails_helper'

RSpec.describe VolunteersController, type: :controller do

	before(:each) do
		@admin = FactoryGirl.create(:admin, :email => "admin@example.com")
		sign_in @admin
		@attributes = FactoryGirl.attributes_for(:volunteer)
		@vol = FactoryGirl.create(:volunteer)
	end

	describe "GET #index" do
		it "responds successfully with an HTTP 200 status code" do
			get :index
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the index template if format html" do
			get :index
		end
	end
	# describe "PATCH #approve" do
	# 	it "responds successfully with an HTTP 302 status code and renders the volunteer path template" do
	# 		post :approve, id: @volunteer.id
	# 		expect(response).to have_http_status(302)
	# 		expect(response).to redirect_to(volunteers_path)
	# 	end
	# 	it "updates volunteer to approved status" do
	# 		v = FactoryGirl.create(:volunteer,:email => "whatever@example.com", :phone => "925-988-9918")
	# 		expect(v.status).to eq(0)
	# 		post :approve, id: v.id, volunteer: FactoryGirl.attributes_for(:approved_volunteer)
	# 		puts v.to_json
	# 		v.reload
	# 		expect(v.status).to eq(1)
	# 	end
	# end

	# describe "GET #ban" do
	# 	it "responds successfully with an HTTP 302 status code and redirects to /volunteers page" do
	# 		get :ban, id: @volunteer.id
	# 		expect(response).to have_http_status(302)
	# 		expect(response).to redirect_to(volunteers_path)
	# 	end
	# 	it "updates volunteer as banned status" do
	# 		t = FactoryGirl.create(:volunteer, :email => "volunteer1@example.com")
	# 		expect(t.status).to eq(0)
	# 		get :ban, id: t.id
	# 		t.reload
	# 		expect(t.status).to eq(2)
	# 	end
	# end

	describe "PUT #ban" do
		it "responds successfully with an HTTP 302 status code and redirects to /volunteers page" do
			patch :ban, id: @vol.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to(volunteers_path)
		end
		it "updates volunteer as banned status" do
			volunteer = FactoryGirl.create(:volunteer, :firstname => "justine", :email => "volunteer@shareprogress.org", :phone => "925-947-5860")
			expect(volunteer.status).to eq(0)
			attributes = FactoryGirl.attributes_for(:banned_volunteer)
			patch :ban, id: volunteer.id
			volunteer.reload
			expect(volunteer.status).to eq(attributes[:status])
		end
	end
	# describe "GET #make_admin" do
	# 	it "responds successfully with an HTTP 302 status code and redirects to /volunteers page" do
	# 		get :make_admin, id: @volunteer.id
	# 		expect(response).to have_http_status(302)
	# 		expect(response).to redirect_to( volunteers_path )
	# 	end
	# 	it "updates volunteer as admin" do
	# 		u = FactoryGirl.create(:volunteer, :email => "volunteer2@example.com")
	# 		expect(u.admin).to be_falsey
	# 		get :make_admin, id: u.id
	# 		u.reload
	# 		expect(u.admin).to be_truthy
	# 	end
	# end
	describe "GET #home" do
		it "responds successfully with an HTTP 200 status code" do
			get :home
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the home template if format html" do
			get :home
			expect(response).to render_template("home")
			expect(response).to render_template("layouts/volunteer")
		end
	end
	

end
