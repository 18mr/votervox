class UpdateLanguageDataType < ActiveRecord::Migration
  def up
  	add_column :voters, :languages, :string, array: true, default: []
    remove_column :voters, :language
  end

  def down
  	add_column :voters, :language, :string
    remove_column :voters, :languages
  end
end
