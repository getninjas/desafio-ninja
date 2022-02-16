class CreateSchedulers < ActiveRecord::Migration[6.1]
  def change
    create_table :schedulers do |t|
      t.datetime :start_meeting_time
      t.datetime :end_meeting_time
      t.string :meeting_description

      t.timestamps
    end
  end
end
