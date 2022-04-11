class CreateSchedule < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.references :room

      t.timestamps
    end
  end
end
