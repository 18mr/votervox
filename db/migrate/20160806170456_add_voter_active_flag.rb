class AddVoterActiveFlag < ActiveRecord::Migration
  def up
  	add_column :voters, :active, :boolean, default: true
  end

  def down
    remove_column :voters, :active
  end
end
