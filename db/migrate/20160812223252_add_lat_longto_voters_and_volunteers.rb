class AddLatLongtoVotersAndVolunteers < ActiveRecord::Migration
  def up
  	add_column :voters, :latitude, :float
  	add_column :voters, :longitude, :float
  	add_column :volunteers, :latitude, :float
  	add_column :volunteers, :longitude, :float
  end

  def down
    remove_column :voters, :latitude
    remove_column :voters, :longitude
    remove_column :volunteers, :latitude
    remove_column :volunteers, :longitude
  end
end
