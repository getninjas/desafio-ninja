class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :open_at
      t.integer :close_at
      t.integer :people_limit_by_meeting
      t.integer :time_limit_by_meeting

      t.timestamps
    end
  end
end
