class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.references :match, index: true, foreign_key: true
      t.integer :duration, default: 0
      t.integer :contact_type
      t.string :message

      t.timestamps null: false
    end
  end
end
