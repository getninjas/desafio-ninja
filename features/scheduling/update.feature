Feature: Atualizar agendamento de sala de reunião

  Background:
    Given uma sala de reunioes
    And um agendamento

  Scenario: Atualizar para um horário disponivel
    And dia e horarios permitidos
    When uma solicitação é realizada para atualizar o agendamento
    Then a sala fica reservada para aquele horario

  Scenario: Atualizar para um horário que ja possui agendamento
    And em um horario ja agendado
    When uma solicitação é realizada para atualizar o agendamento
    Then a solicitação e recusada e uma mensagem de horario ja agendado é retornada

  Scenario: Atualizar para um horario fora do permitido
    And dia permitido e hoario nao permitido
    When uma solicitação é realizada para atualizar o agendamento
    Then a solicitação e recusada e uma mensagem de horario fora do permitido é retornada