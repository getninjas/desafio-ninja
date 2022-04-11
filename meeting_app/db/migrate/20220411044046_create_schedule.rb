class CreateSchedule < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.string :title
      t.integer :start_hour
      t.integer :end_hour
      t.datetime :date
      t.references :room

      t.timestamps
    end
  end
end
