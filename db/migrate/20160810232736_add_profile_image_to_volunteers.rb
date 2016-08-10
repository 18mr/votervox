class AddProfileImageToVolunteers < ActiveRecord::Migration
  def self.up
    add_attachment :volunteers, :profile_image
  end

  def self.down
    remove_attachment :volunteers, :profile_image
  end
end
