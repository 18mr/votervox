class ActionNetwork
  def initialize
    @api_route = Rails.application.secrets.actionnetwork_api_route
  	@api_key = Rails.application.secrets.actionnetwork_api_key
  end

  def make_request method, data=nil
    url = @api_route + method
    puts "URL: "+url
    puts "Data: "+data.to_json if !data.nil?
    headers = {
      :content_type => :json,
      :accept => :json,
      :'api-key' => @api_key
    }
    begin
      if data.nil?
        RestClient.get url, headers
      else
        RestClient.post url, data.to_json, headers
      end
    rescue => e
      e.response
    end
  end

  def submit_form action_id, data
    method = "/forms/#{action_id}/submissions/"
    data = {
      "originating_system" => "VoterVOX",
      "person" => {
        "family_name" => data[:lastname],
        "given_name" => data[:firstname],
        "postal_addresses" => [ { "postal_code" => data[:zip] } ],
        "email_addresses" => [ { "address" => data[:email] } ]
      }      
    }
    self.make_request method, data
  end
end