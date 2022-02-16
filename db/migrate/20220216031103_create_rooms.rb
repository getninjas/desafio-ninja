class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.datetime :open_at
      t.datetime :close_at
      t.int :people_limit_by_meeting
      t.int :time_limit_by_meeting

      t.timestamps
    end
  end
end
