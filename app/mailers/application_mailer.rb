module MailerHelper
  def html_format text
  	text.gsub("\n","<br/>\n").html_safe
  end
end

class ApplicationMailer < ActionMailer::Base
  helper MailerHelper

  default from: "VoterVOX <notify@votervox.org>"
  layout 'mailer'

  def full_url path
  	['http://', ActionMailer::Base.default_url_options[:host], path].join('')
  end
end
