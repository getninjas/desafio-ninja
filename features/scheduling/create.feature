Feature: Criar agendamento de sala de reunião

  Scenario: Horário disponivel
    Given uma sala com horario disponivel
    When uma solicitação é realizada para o agendamento
    Then a sala fica reservada para aquele horario
