class CreateMeetings < ActiveRecord::Migration[6.1]
  def change
    create_table :meetings do |t|
      t.string :title
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
