class VolunteersController < ApplicationController
	before_action :authenticate_admin!, except: [:home]
	before_action :authenticate_volunteer!, only: [:home]
	layout "volunteer", :except => :new


	### ADMIN ROUTES
	def index
		@languages = params[:languages] || []
		@location = params[:location] || ''

		if current_org.nil?
			@pending_volunteers = Volunteer.unapproved
			@approved_volunteers = Volunteer.approved
			@banned_volunteers = Volunteer.banned
		else
			@pending_volunteers = current_org.volunteers.unapproved
			@approved_volunteers = current_org.volunteers.approved
			@banned_volunteers = current_org.volunteers.banned
		end

		# Filter based on language and location
		if @languages.present?
			@pending_volunteers = @pending_volunteers.reject{ |v| (v.languages & @languages).empty? }
			@approved_volunteers = @approved_volunteers.reject{ |v| (v.languages & @languages).empty? }
			@banned_volunteers = @banned_volunteers.reject{ |v| (v.languages & @languages).empty? }
		end
		if @location.present?
			@pending_volunteers = @pending_volunteers.reject{ |v| v.city != @location && v.state != @location }
			@approved_volunteers = @approved_volunteers.reject{ |v| v.city != @location && v.state != @location }
			@banned_volunteers = @banned_volunteers.reject{ |v| v.city != @location && v.state != @location }
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


	### VOLUNTEER ROUTES
	def home
	end

	protected

	def matching_volunteer?
		current_org.nil? || current_org == @volunteer.organization
	end
end
