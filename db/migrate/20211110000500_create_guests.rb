class CreateGuests < ActiveRecord::Migration[6.1]
  def up
    create_table :guests, id: :uuid do |t|
      t.string :email, null: false

      t.timestamps
    end

    add_index :guests, :email, unique: true
  end

  def down
    drop_table :guests
  end
end
