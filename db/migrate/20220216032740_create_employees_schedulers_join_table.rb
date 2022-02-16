class CreateEmployeesSchedulersJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :employee_schedulers, id: false do |t|
      t.bigint :employee_id
      t.bigint :scheduler_id
    end

    add_index :employee_schedulers, :employee_id
    add_index :employee_schedulers, :scheduler_id
  end
end
