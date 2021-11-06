class CreateSchedules < ActiveRecord::Migration[6.1]
  def up
    create_table :schedules, id: :uuid do |t|
      t.references :room, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.timestamp :start_time
      t.timestamp :end_time

      t.timestamps
    end

    add_index :schedules, [:room_id, :start_time, :end_time]
  end

  def down
    drop_table :schedules
  end
end
