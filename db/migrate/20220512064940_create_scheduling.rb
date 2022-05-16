class CreateScheduling < ActiveRecord::Migration[6.1]
  def change
    create_table :schedulings do |t|
      t.belongs_to :meeting_room
      t.datetime :time
      t.string :responsible

      t.timestamps
    end
  end
end
