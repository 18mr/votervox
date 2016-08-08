class MetricsController < ApplicationController
	include ApplicationHelper
	before_filter :authenticate_admin!

	def index
		@start_dt = params[:start_date].to_date rescue 1.week.ago
		@end_dt = params[:end_date].to_date rescue 1.second.ago
		@timeframe = params[:timeframe]
		@metrics = metrics_data

		respond_to do |format|
			format.html do
				render :index
			end
			format.json do
				render json: @metrics
			end
		end
	end

	private

	def metrics_data
		# Load matching records
		voters = Voter.where("created_at < ?", @end_dt)
		unmatched_voters = Voter.unmatched.select{ |v| v.created_at < @end_dt }
		if current_org.nil?
			volunteers = Volunteer.where("created_at < ?", @end_dt)
			volunteers_active = Volunteer.active.where("created_at < ?", @end_dt)
			matches = Match.where("created_at < ?", @end_dt)
			interactions = Interaction.where("created_at >= ? AND created_at < ?", @start_dt, @end_dt)
		else
			volunteers = current_org.volunteers.where("volunteers.created_at < ?", @end_dt)
			volunteers_active = current_org.volunteers.active.where("volunteers.created_at < ?", @end_dt)
			matches = current_org.matches.where("matches.created_at < ?", @end_dt)
			interactions = current_org.interactions.where("interactions.created_at >= ? AND interactions.created_at < ?", @start_dt, @end_dt)
		end

		# Calculate metrics
		language_count = language_list.count
		visitors = Visit.all.count
		registrations = voters.select{ |v| v.created_at > @start_dt }.count + volunteers.select{ |v| v.created_at > @start_dt }.count
		durations = interactions.map(&:duration).select{ |d| d > 0 }
		average_duration = (durations.sum / durations.count).round rescue 0
		{
			:language_count => language_count,
			:site_visitors => visitors,
			:registrations => registrations,
			:views_per_language => (visitors / language_count).round,
			:volunteer_count => volunteers.count,
			:active_volunteer_count => volunteers_active.count,
			:new_volunteer_count => volunteers.select{ |v| v.created_at > @start_dt }.count,
			:average_duration => average_duration,
			:min_duration => durations.min,
			:max_duration => durations.max,
			:voter_count => voters.count,
			:active_match_count => matches.select{ |m| m.active? }.count,
			:new_voter_count => voters.select{ |v| v.created_at > @start_dt }.count,
			:completed_match_count => matches.select{ |m| m.completed? }.count,
			:unmatched_voter_count => unmatched_voters.count
		}
	end
end
