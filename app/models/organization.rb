class Organization < ActiveRecord::Base
	validates :name, length: { in: 1..128 }
end
