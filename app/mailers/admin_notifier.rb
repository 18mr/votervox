class AdminNotifier < ApplicationMailer
	def feedback data
		@name = data[:name]
		@contact = data[:contact]
		@message = data[:message]
		mail(:to => ENV['ADMIN_EMAIL'], :subject => data[:subject])
	end
end
