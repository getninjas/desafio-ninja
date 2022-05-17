Feature: Atualizar agendamento de sala de reunião

  Background:
    Given uma sala de reunioes
    And um agendamento

  Scenario: Atualizar para um horário disponivel
    And dia e horarios permitidos
    When uma solicitação é realizada para atualizar o agendamento
    Then a sala fica reservada para aquele horario