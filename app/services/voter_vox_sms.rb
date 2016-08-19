class VoterVoxSms
  def initialize
    account_sid = Rails.application.secrets.twilio_sid
    auth_token = Rails.application.secrets.twilio_token
    @number = Rails.application.secrets.twilio_number

    @client = Twilio::REST::Client.new account_sid, auth_token rescue nil
  end

  def send phone, message
    return unless @client.present? && @number.present?

    begin
      @client.messages.create(
        from: @number,
        to: phone,
        body: message
      )
    rescue
      nil
    end
  end

end