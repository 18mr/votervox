class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :voter, index: true, foreign_key: true
      t.references :volunteer, index: true, foreign_key: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
