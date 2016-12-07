require 'rails_helper'

RSpec.describe VolunteersController, type: :controller do

	before(:each) do
		@admin = FactoryGirl.create(:admin, :email => "admin@example.com")
		sign_in @admin
	end

	describe "GET #index" do
		it "responds successfully with an HTTP 200 status code" do
			get :index
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the index template if format html" do
			get :index
			expect(response).to render_template('index')
			expect(response).to render_template("layouts/volunteer")
		end
		it "assigns correct variables for the view when admin has no org" do	
			#remove organization from admin
			@admin.organization = nil
			@admin.save

			@pending_volunteers = Volunteer.unapproved
			@approved_volunteers = Volunteer.approved
			@banned_volunteers = Volunteer.banned

			get :index

			expect(assigns(:pending_volunteers)).to eq( @pending_volunteers )
			expect(assigns(:approved_volunteers)).to eq( @approved_volunteers )
			expect(assigns(:banned_volunteers)).to eq( @banned_volunteers )
		end
		it "assigns correct variables for the view when admin has org assigned" do
			organization = FactoryGirl.create(:organization, :name => "ShareProgress")
			banned_volunteers = FactoryGirl.create_list(:banned_volunteer, 2, :organization => organization)
			approved_volunteers  = FactoryGirl.create_list(:approved_volunteer, 2, :organization => organization)
			pending_volunteers = FactoryGirl.create_list(:volunteer, 3, :organization => organization)
			#assign admin to the same org as all the newly created volunteers
			@admin.organization = organization
			@admin.save
			get :index
			#add @admin to approved volunteers array
			approved_volunteers.push(@admin)
			expect(assigns(:pending_volunteers)).to eq( pending_volunteers )
			expect(assigns(:approved_volunteers)).to eq ( approved_volunteers )
			expect(assigns(:banned_volunteers)).to eq( banned_volunteers )
		end
		it "filters based on languages selected" do
			organization = FactoryGirl.create(:organization, :name => "ShareProgress")
			banned_volunteers = FactoryGirl.create_list(:banned_volunteer, 2, :organization => organization, :languages => ['Cantonese'])
			approved_volunteers  = FactoryGirl.create_list(:approved_volunteer, 2, :organization => organization, :languages => ['Cantonese'])
			pending_volunteers = FactoryGirl.create_list(:volunteer, 3, :organization => organization, :languages => ['Cantonese'])
			@admin.organization = organization
			@admin.save

			get :index, :languages => ['Cantonese']
			expect(assigns(:pending_volunteers)).to eq( pending_volunteers )
			expect(assigns(:approved_volunteers)).to eq ( approved_volunteers )
			expect(assigns(:banned_volunteers)).to eq( banned_volunteers )
		end

		it "filters based on location selected" do
			organization = FactoryGirl.create(:organization, :name => "ShareProgress")
			banned_volunteers = FactoryGirl.create_list(:banned_volunteer, 2, :organization => organization, :city => 'Portland', :state => 'OR')
			approved_volunteers  = FactoryGirl.create_list(:approved_volunteer, 2, :organization => organization, :city => 'Portland', :state => 'OR')
			pending_volunteers = FactoryGirl.create_list(:volunteer, 2, :organization => organization, :city => 'Portland', :state => 'OR')
			@admin.organization = organization
			@admin.save

			get :index, :location => "Portland"
			expect(assigns(:pending_volunteers)).to eq( pending_volunteers )
			expect(assigns(:approved_volunteers)).to eq ( approved_volunteers )
			expect(assigns(:banned_volunteers)).to eq( banned_volunteers )
		end
	end

	describe "PATCH #approve" do
		it "responds successfully with an HTTP 302 status code and redirects to /volunteers page" do
			volunteer = FactoryGirl.create(:volunteer)
			patch :approve, id: volunteer.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to(volunteers_path)
		end
		it "updates volunteer as approved status" do
			#create new shared organization, since only admin from same org can ban
			organization = FactoryGirl.create(:organization, :name => "ShareProgress")
			volunteer = FactoryGirl.create(:volunteer, :firstname => "justine", :email => "volunteer@shareprogress.org", :phone => "925-947-5860", :organization => organization)
			@admin.organization = organization
			@admin.save
			expect(volunteer.status).to eq(0)
			attributes = FactoryGirl.attributes_for(:approved_volunteer)
			patch :approve, id: volunteer.id
			volunteer.reload
			expect(volunteer.status).to eq(attributes[:status])
			#if different organization, the admin can't approve the volunteer
			volunteer2 = FactoryGirl.create(:volunteer)
			patch :approve, id: volunteer.id
			volunteer2.reload
			expect(volunteer2.status).to eq(0)
		end
	end

	describe "PATCH #ban" do
		it "responds successfully with an HTTP 302 status code and redirects to /volunteers page" do
			volunteer = FactoryGirl.create(:volunteer)
			patch :ban, id: volunteer.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to(volunteers_path)
		end
		it "updates volunteer as banned status" do
			#create new shared organization, since only admin from same org can ban
			organization = FactoryGirl.create(:organization, :name => "ShareProgress")
			volunteer = FactoryGirl.create(:volunteer, :firstname => "justine", :email => "volunteer@shareprogress.org", :phone => "925-947-5860", :organization => organization)
			@admin.organization = organization
			@admin.save
			expect(volunteer.status).to eq(0)
			attributes = FactoryGirl.attributes_for(:banned_volunteer)
			patch :ban, id: volunteer.id
			volunteer.reload
			expect(volunteer.status).to eq(attributes[:status])
			#if different organization, the admin can't ban the volunteer
			volunteer2 = FactoryGirl.create(:volunteer)
			patch :approve, id: volunteer.id
			volunteer2.reload
			expect(volunteer2.status).to eq(0)
		end
	end
	describe "PATCH #make_admin" do
		it "responds successfully with an HTTP 302 status code and redirects to /volunteers page" do
			volunteer = FactoryGirl.create(:volunteer)
			patch :make_admin, id: volunteer.id
			expect(response).to have_http_status(302)
			expect(response).to redirect_to( volunteers_path )
		end
		it "updates volunteer as admin" do
			#create new shared organization, since only admin from same org can ban
			organization = FactoryGirl.create(:organization, :name => "ShareProgress")
			volunteer = FactoryGirl.create(:volunteer, :firstname => "justine", :email => "volunteer@shareprogress.org", :phone => "925-947-5860", :organization => organization)
			@admin.organization = organization
			@admin.save
			expect(volunteer.admin).to be_falsey
			patch :make_admin, id: volunteer.id
			volunteer.reload
			expect(volunteer.admin).to be_truthy
			#if different organization, the admin can't make the volunteer an admin
			volunteer2 = FactoryGirl.create(:volunteer)
			patch :approve, id: volunteer.id
			volunteer2.reload
			expect(volunteer2.admin).to be_falsey
		end
	end
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
