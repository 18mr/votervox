desc "Notify volunteers without active matches about voters searching for matches near them"
task :send_new_matches => :environment do
	if Time.now.wednesday? || Time.now.saturday? || true
		volunteers = Volunteer.approved.select{ |vol| vol.matches.active.empty? }
		volunteers.each do |vol|
			voters = vol.match_requests 1
			if voters.present?
				VolunteerNotifier.new_matches(vol,voters).deliver_now
			end
		end
	end
end

desc "Ask volunteers with active matches at least one week old if match complete"
task :check_match_completion => :environment do
	if Time.now.thursday? || true
		volunteers = Volunteer.approved.select{ |vol| vol.matches.active.select{ |m| m.created_at < 1.week.ago }.present? }
		volunteers.each do |vol|
			match = vol.matches.active.select{ |m| m.created_at < 1.week.ago }.first
			VolunteerNotifier.completion_check(vol,match).deliver_now
		end
	end
end
