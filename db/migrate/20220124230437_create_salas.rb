class CreateSalas < ActiveRecord::Migration[7.0]
  def change
    create_table :salas do |t|
      t.string :nome

      t.timestamps
    end
    Sala.create!([
                   { nome: 'Fênix' },
                   { nome: 'Spartans' },
                   { nome: 'Lions' },
                   { nome: 'Supremos' }
                 ])
  end
end
