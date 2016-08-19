class AddZipToVotersAndVolunteers < ActiveRecord::Migration
  def up
  	add_column :voters, :zip, :string
  	add_column :volunteers, :zip, :string
  end

  def down
    remove_column :voters, :zip
    remove_column :volunteers, :zip
  end
end
