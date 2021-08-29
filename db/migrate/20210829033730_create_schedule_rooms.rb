class CreateScheduleRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :schedule_rooms do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.date :scheduled_date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
