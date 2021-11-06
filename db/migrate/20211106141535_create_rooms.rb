class CreateRooms < ActiveRecord::Migration[6.1]
  def up
    create_table :rooms, id: :uuid do |t|
      t.text :name

      t.timestamps
    end
  end

  def down
    drop_table :rooms
  end
end
