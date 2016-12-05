require 'rails_helper'

RSpec.describe MetricsController, type: :controller do

	before(:each) do
		@admin = FactoryGirl.create(:admin, :email => "test@example.com")
		sign_in @admin
	end

	describe "GET #index" do
		it "responds successfully with an HTTP 200 status code" do
			get :index
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
		it "renders the index template if format html" do
			get :index, :format => 'html'
			expect(response).to render_template("index")
			expect(response).to render_template("layouts/volunteer")
		end
	end
end
