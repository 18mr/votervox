class OrganizationsController < ApplicationController
	before_filter :authenticate_admin!
	layout "volunteer"
	
	def index
		@organizations = Organization.all
	end

	def new
		@organization = Organization.new
	end

	def create
		@organization = Organization.new(organization_params)

		if @organization.save
			redirect_to organizations_path
		else
			render 'new'
		end
	end

	def destroy
	    @organization = Organization.find(params[:id])
	    @organization.destroy

	    redirect_to organizations_path
	end

	private
		def organization_params
			params.require(:organization).permit(:name)
		end

end
