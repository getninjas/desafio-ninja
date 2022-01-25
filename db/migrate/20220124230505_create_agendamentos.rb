class CreateAgendamentos < ActiveRecord::Migration[7.0]
  def change
    create_table :agendamentos do |t|
      t.date :data
      t.time :horario_inicio
      t.time :horario_final
      t.references :agenda, null: false, foreign_key: true

      t.timestamps
    end
  end
end
