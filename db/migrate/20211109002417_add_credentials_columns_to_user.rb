class AddCredentialsColumnsToUser < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :password_hash, :varchar
  end

  def down
    remove_column :users, :password_hash
  end
end
