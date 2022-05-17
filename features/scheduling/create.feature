Feature: Criar agendamento de sala de reunião

  Background:
    Given uma sala de reunioes

  Scenario: Horário disponivel
    And dia e horarios permitidos
    When uma solicitação é realizada para o agendamento
    Then a sala fica reservada para aquele horario

  Scenario: Horário ja possui agendamento
    And em um horario ja agendado
    When uma solicitação é realizada para o agendamento
    Then a solicitação e recusada e uma mensagem de horario ja agendado é retornada

  Scenario: Dia permitido e horario fora do permitido
    And dia permitido e hoario nao permitido
    When uma solicitação é realizada para o agendamento
    Then a solicitação e recusada e uma mensagem de horario fora do permitido é retornada