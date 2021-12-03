class CreateMeetings < ActiveRecord::Migration[6.1]
  def change
    create_table :meetings do |t|
      t.datetime :starts_at
      t.datetime :end_at
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
