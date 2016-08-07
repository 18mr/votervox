class DocumentsController < ApplicationController
	before_filter :authenticate_volunteer!, only: [:volunteer_index, :volunteer_show, :new, :create]
	before_filter :authenticate_admin!, only: [:update, :destroy]

	layout :document_layouts

	### VOLUNTEER ROUTES
	def volunteer_index
		@languages = params[:languages] || []
		@resource_type = params[:resource_type] || []
		@location = params[:location] || ''
		@documents = Document.filter @languages, @resource_type, @location
		render 'index', layout: 'volunteer'
	end

	def volunteer_show
		@document = Document.find params[:id]
		render 'show'
	end

	def new
		@document = Document.new
	end

	def create
		@document = Document.new(document_params)

		if @document.save
			redirect_to volunteer_show_document_path(@document)
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
		redirect_to volunteer_documents_path(document_filter_params) if volunteer_signed_in?
		@languages = params[:languages] || []
		@resource_type = params[:resource_type] || []
		@location = params[:location] || ''
		@documents = Document.filter @languages, @resource_type, @location
	end

	def show
		redirect_to volunteer_show_document_path(params[:id]) if volunteer_signed_in?
		@document = Document.find params[:id]
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

	def document_layouts
		%w(index show).include?(action_name) ? "voter" : "volunteer"
	end


end
