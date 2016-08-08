module Ahoy
  class Event < ActiveRecord::Base
    include Ahoy::Properties

    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :volunteer
  end
end
