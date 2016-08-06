class AddCityState < ActiveRecord::Migration
  def up
  	add_column :voters, :city, :string
  	add_column :voters, :state, :string
  	add_column :volunteers, :city, :string
  	add_column :volunteers, :state, :string
  end

  def down
    remove_column :voters, :city
    remove_column :voters, :state
    remove_column :volunteers, :city
    remove_column :volunteers, :state
  end
end
