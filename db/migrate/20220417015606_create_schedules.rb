class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules, id: :uuid do |t|
      t.references :room, index: true, type: :uuid, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, index: true, type: :uuid, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end

    add_index :schedules, :start_time
    add_index :schedules, :end_time
  end
end
