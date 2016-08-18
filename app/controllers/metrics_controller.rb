class MetricsController < ApplicationController
	include ApplicationHelper
	
	before_action :authenticate_admin!
	layout 'volunteer'

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

		# Get metric datasets
		new_voters = voters.select{ |v| v.created_at > @start_dt }
		new_volunteers = volunteers.select{ |v| v.created_at > @start_dt }
		active_matches = matches.select{ |m| m.active? }
		completed_matches = matches.select{ |m| m.completed? }
		registrations = voters.select{ |v| v.created_at > @start_dt }.count + volunteers.select{ |v| v.created_at > @start_dt }.count
		durations = interactions.map(&:duration).select{ |d| d > 0 }

		# Calculate language datasets
		voter_languages = voters.map(&:languages).flatten
		new_voter_languages = new_voters.map(&:languages).flatten
		unmatched_voter_langauges = unmatched_voters.map(&:languages).flatten
		volunteer_languages = volunteers.map(&:languages).flatten
		active_volunteer_languages = volunteers_active.map(&:languages).flatten
		new_volunteer_languages = new_volunteers.map(&:languages).flatten
		active_match_languages = active_matches.map(&:languages).flatten
		completed_match_languages = completed_matches.map(&:languages).flatten
		language_duration_map = interactions.select{ |i| i.duration > 0 }.map do |interaction|
			interaction.match.languages.map{ |l| {:label => l, :value => interaction.duration} }
		end
		puts "Duration stats:" + language_duration_map.to_json
		language_durations = aggregate_hashes(language_duration_map.flatten)
		puts "Duration processed:" + language_durations.to_json

		{
			:language_count => language_list.count,
			:site_visitors => Visit.count,
			:registrations => registrations,
			:registrations_by_language => count_occurrences(voter_languages + volunteer_languages),
			:views_per_language => (Visit.count / language_list.count).round,
			:volunteer_count => volunteers.count,
			:volunteer_count_by_language => count_occurrences(volunteer_languages),
			:active_volunteer_count => volunteers_active.count,
			:active_volunteer_count_by_language => count_occurrences(active_volunteer_languages),
			:new_volunteer_count => new_volunteers.count,
			:new_volunteer_count_by_language => count_occurrences(new_volunteer_languages),
			:average_duration => array_average(durations),
			:average_duration_by_language => Hash[language_durations.map{|k,arr| [k, array_average(arr)] } ],
			:min_duration => durations.min,
			:min_duration_by_language => Hash[language_durations.map{|k,arr| [k, arr.min] } ],
			:max_duration => durations.max,
			:max_duration_by_language => Hash[language_durations.map{|k,arr| [k, arr.max] } ],
			:voter_count => voters.count,
			:voter_count_by_language => count_occurrences(voter_languages),
			:active_match_count => active_matches.count,
			:active_match_by_language => count_occurrences(active_match_languages),
			:new_voter_count => new_voters.count,
			:new_voter_count_by_language => count_occurrences(new_voter_languages),
			:completed_match_count => completed_matches.count,
			:completed_match_by_language => count_occurrences(completed_match_languages),
			:unmatched_voter_count => unmatched_voters.count,
			:unmatched_voters_count_by_language => count_occurrences(unmatched_voter_langauges)
		}
	end

	def array_average arr
		(arr.sum / arr.count).round rescue 0
	end
	def count_occurrences arr
		arr.inject(Hash.new(0)) {|h,x| h[x] += 1; h}
	end
	def aggregate_hashes arr
		arr.inject(Hash.new {|h,k| h[k]=[]}) {|h,x| h[x[:label]] << x[:value]; h}
	end
end
