class AddLocaleToVoters < ActiveRecord::Migration
  def up
  	add_column :voters, :locale, :string, default: 'en'
  end

  def down
    remove_column :voters, :locale
  end
end
