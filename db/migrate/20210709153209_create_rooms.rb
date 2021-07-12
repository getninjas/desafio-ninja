class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.integer :availability_days, array: true, null: false, default: [1, 2, 3, 4, 5]
      t.string :availability_start_time, default: '09:00', null: false
      t.string :availability_end_time, default: '18:00', null: false

      t.timestamps
    end
  end
end
