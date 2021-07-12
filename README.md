# Descrição do Problema
Temos um problema grande com reuniões, elas são muitas e temos poucas salas disponíveis.
Precisamos de uma agenda para nos mantermos sincronizados e esse será seu desafio!
Temos 4 salas e podemos usá-las somente em horário comercial, de segunda a sexta das 09:00 até as 18:00.
Sua tarefa será de criar uma API REST que crie, edite, mostre e delete o agendamento dos horários para que os usuários não se percam ao agendar as salas.

# Notas
- O teste deve ser escrito utilizando Ruby e Ruby on Rails
- Utilize as gems que achar necessário
- Não faça squash dos seus commits, gostamos de acompanhar a evolução gradual da aplicação via commits.
- Estamos avaliando coisas como design, higiene do código, confiabilidade e boas práticas
- Esperamos testes automatizados. 
- A aplicação deverá subir com docker-compose
- Crie um README.md descrevendo a sua solução e as issues caso houver
- O desafio pode ser entregue abrindo um pull request ou fazendo um fork do repositório 


# Resolução

Criei uma tebla rooms que representa as salas do problema, parar criar as salas com as especificações do problema basta rodar a rake ```sample_data:rooms```. Cada registro possui suas próprias configurações então podemos ter salas com configurações diferentes do problemas deixando a solução mais escalável.

A tabela appointments representa os agendamentos. Cada sala pode ter vários agendamentos, logo tabela room possui o relacionamento de um pra muitos com a tabela appointments. Com a aplicação conseguimos criar, editar, listar, mostrar e destruir agendamentos. Implementei a validação time_window_disjunction pra garantir que um agendamento não intersecte outros existentes. Para garantir que um agendamento respeite as regras da sala implementei a validação room_availability e por último implementei mais uma que garantisse que o tempo final do agendamento não seja antes do tempo inicial.

Os campos que armazenam o horário de disponibilidade das salas é uma string, pois só precisava da informção de hora. Para garantir a formatação criei o validador customizado HourStringFormatValidator que faz a verificação com o uso de regex.

Pra ajudar a visualizar a modelagem da resolução problema eu fiz esse diagrama: https://dbdiagram.io/d/60e6269d7e498c3bb3eca6d2