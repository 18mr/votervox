class VolunteersController < ApplicationController
	before_filter :authenticate_admin!
	layout "volunteer", :except => :new

	def index
		if current_org.nil?
			@volunteers = Volunteer.active
		else
			@volunteers = Volunteer.active.where(:organization => current_org.id)
		end
	end

	def approve
		@volunteer = Volunteer.find params[:id]
		if matching_volunteer?
			@volunteer.update(:status => 1)
		end

        redirect_to volunteers_path
	end

	def ban
		@volunteer = Volunteer.find params[:id]
		if matching_volunteer?
			@volunteer.update(:status => 2)
		end

        redirect_to volunteers_path
	end

	def make_admin
		@volunteer = Volunteer.find params[:id]
		if matching_volunteer?
			@volunteer.update(:admin => true)
		end
		
        redirect_to volunteers_path
	end

	protected

	def matching_volunteer?
		current_org.nil? || current_org == @volunteer.organization
	end
end
