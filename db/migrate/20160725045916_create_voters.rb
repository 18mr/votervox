class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters do |t|
      t.string :firstname
      t.string :lastname
      t.string :communication_mode
      t.string :contact
      t.string :address
      t.string :language
      t.integer :english_comfort
      t.boolean :first_time_voter

      t.timestamps null: false
    end
  end
end
