class CreateMeetings < ActiveRecord::Migration[6.1]
  def change
    create_table :meetings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :subject, default: 'Reunião de trabalho'

      t.timestamps
    end
  end
end
