class CreateAgendas < ActiveRecord::Migration[7.0]
  def change
    create_table :agendas do |t|
      t.references :sala, null: false, foreign_key: true

      t.timestamps
    end
    Sala.all.each do |sala|
      Agenda.create!(sala_id: sala.id)
    end
  end
end
