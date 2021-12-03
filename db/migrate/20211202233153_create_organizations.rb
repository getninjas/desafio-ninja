class CreateOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :adress
      t.integer :number_of_rooms
      t.boolean :work_on_weekend
      t.string :business_hours_start
      t.string :business_hours_end

      t.timestamps
    end
  end
end
