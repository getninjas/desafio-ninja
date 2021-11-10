class CreateGuestScheduleTable < ActiveRecord::Migration[6.1]
  def up
    create_table :guests_schedules, id: :uuid do |t|
      t.references :guest, null: false, foreign_key: true, type: :uuid
      t.references :schedule, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :guests_schedules
  end
end
