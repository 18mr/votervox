require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do

	before(:each) do
		@admin = FactoryGirl.create(:admin, :email => "test@example.com")
		sign_in @admin
		@organization = FactoryGirl.create(:organization)
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
	end
	describe "GET #new" do
		it "responds successfully with an HTTP 200 status code" do
			get :new
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the index template if format html" do
			get :new
			expect(response).to render_template("new")
			expect(response).to render_template("layouts/volunteer")
		end
	end

	describe "POST #create" do
		it "responds successfully with an HTTP 302 status code and redirects to /organizations page" do
			post :create, organization: FactoryGirl.attributes_for(:organization)
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( organizations_path )
			
		end
	end
	
	describe "GET #destroy" do
		it "responds successfully with an HTTP 302 status code and redirects to /organizations pag" do
			get :destroy, id: @organization.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to(organizations_path)
			
		end
	end
end
