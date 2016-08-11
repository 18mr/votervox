class AddFileToDocuments < ActiveRecord::Migration
  def self.up
    add_attachment :documents, :file
  end

  def self.down
    remove_attachment :documents, :file
  end
end
