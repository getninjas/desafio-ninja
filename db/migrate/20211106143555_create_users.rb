class CreateUsers < ActiveRecord::Migration[6.1]
  def up
    create_table :users, id: :uuid do |t|
      t.text :email

      t.timestamps
    end

    add_index :users, :email
  end

  def down
    drop_table :users
  end
end
