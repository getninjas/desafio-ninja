class CreateSchedulersEmployeesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms_schedulers, id: false do |t|
      t.bigint :room_id
      t.bigint :scheduler_id
    end

    add_index :rooms_schedulers, :room_id
    add_index :rooms_schedulers, :scheduler_id
  end
end
