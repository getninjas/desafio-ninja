class AddOrganizationToRooms < ActiveRecord::Migration[6.1]
  def change
    add_reference :rooms, :organization, null: false, foreign_key: true
  end
end
