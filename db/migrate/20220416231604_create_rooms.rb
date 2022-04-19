class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms, id: :uuid do |t|
      t.string :description
      t.integer :number
      t.timestamps
    end
  end
end
