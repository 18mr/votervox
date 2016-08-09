class DocumentsController < ApplicationController
	before_action :authenticate_volunteer!, only: [:new, :create]
	before_action :authenticate_admin!, only: [:update, :destroy]
	before_action :identify_voter!, only: [:index, :show]
	layout "volunteer"

	### VOLUNTEER ROUTES
	def new
		@document = Document.new
	end

	def create
		@document = Document.new(document_params)

		if @document.save
			flash[:notice] = "Thank you for uploading your translated document!"
			redirect_to @document
		else
			render 'new'
		end
	end

	
	### ADMIN ROUTES
	def update
		@document = Document.find params[:id]
		@document.update(document_status_params)

		redirect_to volunteer_documents_path
	end

	def destroy
		@document = Document.find params[:id]
		@document.destroy

		redirect_to volunteer_documents_path
	end


	### VOTER ROUTES
	def index
		@languages = params[:languages] || []
		@resource_type = params[:resource_type] || []
		@location = params[:location] || ''
		@documents = Document.filter @languages, @resource_type, @location

		authenticate_render 'index'
	end

	def show
		@document = Document.find params[:id]
		
		authenticate_render 'show'
	end

	private

	def document_params
		params.require(:document).permit(:name, :language, :translated_language, :resource_type,
			:location, :location_type).merge(:submitter_id => current_volunteer.id)
	end
	def document_status_params
		params.require(:document).permit(:status)
	end
	def document_filter_params
		params.permit({:languages => []}, {:resource_type => []}, :location)
	end

end
