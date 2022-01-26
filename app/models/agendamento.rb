class Agendamento < ApplicationRecord
  HORARIO_COMERCIAL_INICIO = '09:00'.freeze
  HORARIO_COMERCIAL_FINAL = '18:00'.freeze

  belongs_to :agenda
  validate :horario_valido?
  validate :validar_overlaps
  validate :horario_comercial

  private

  def horario_valido?
    errors.add(:base, 'Horário inicial maior que horário Final') if horario_inicio > horario_final
  end

  def validar_overlaps
    if horario_inicio && horario_final && horario_inicio < horario_final
      agendamentos = Agendamento.where(data: data, agenda_id: agenda_id).where.not(id: id)
                                .where("(horario_inicio, horario_final) OVERLAPS (cast('#{horario_inicio}' as TIME), cast('#{horario_final}' as TIME))")
      errors.add(:base, 'Já existe um agendamento para o mesmo dia/horário') if agendamentos.count > 0
    end
  end

  def horario_comercial
    errors.add(:base, 'O dia/horario Selecionado é fora do horário comercial') if fora_horario_comercial
  end

  def fora_horario_comercial
    dia = data.on_weekday?
    horario = horario_inicio > HORARIO_COMERCIAL_INICIO || horario_final > HORARIO_COMERCIAL_FINAL

    return unless dia && horario
  end
end
