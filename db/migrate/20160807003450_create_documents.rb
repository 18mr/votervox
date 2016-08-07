class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :submitter, references: :volunteers, index: true
      t.string :name
      t.string :language
      t.string :translated_language
      t.string :resource_type
      t.string :location
      t.string :location_type
      t.integer :status, default: 0

      t.timestamps null: false
    end
    add_foreign_key :documents, :volunteers, column: :submitter_id
  end
end
