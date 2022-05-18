# Desafio Ninja - Agenda

## Descrição do Problema
Temos um problema grande com reuniões, elas são muitas e temos poucas salas disponíveis.
Precisamos de uma agenda para nos mantermos sincronizados e esse será seu desafio!
Temos 4 salas e podemos usá-las somente em horário comercial, de segunda a sexta das 09:00 até as 18:00.
Sua tarefa será de criar uma API REST que crie, edite, mostre e delete o agendamento dos horários para que os usuários não se percam ao agendar as salas.


## Solução aplicada
Partindo do princípio de que todas as salas são iguais, a solução desenvolvida para a aplicação foi de que, para a criação de uma reunião, será necessário somente as datas de início e fim da reunião, assunto da reunião(se houver) e lista de convidados(se houver).
Esta solução foi pensada com a finalidade de reduzir as requisições feitas pelo usuário, pois a aplicação procurará horário disponível nas salas cadastradas, criando a reunião na primeira sala disponível encontrada.
Dessa maneira, o usuário fará apenas uma requisição por horário.
Foram disponibilizadas rotas para que os usuários possam acessar uma lista com dados das reuniões que criaram e, também, reuniões que foram convidados.
Bem como, adicionadas regras de privacidade onde usuário só podem interagir com reuniões ligadas à eles.


## [Documentação da aplicação](http://localhost:3000/api-docs/index.html)
Foi disponibilizado um usuário para interação com a aplicação.
- email: `ninja-dev@getninjas.com.br`
- senha: `123456`
Os demais usuários estão presentes no arquivo: `db/seeds.rb`

## Lista de Comandos
- ### Buildar e rodar a aplicação
  `docker-compose up --build`
- ### Criar, migrar e popular banco de dados
  `docker-compose run web bundle exec rails db:drop db:create db:migrate db:seed`
- ### Acessar terminal da aplicação
  `docker-compose exec web bash`
- ### Acessar console do Rails
  `docker-compose run web bundle exec rails c`
- ### Rodar specs
  `docker-compose run web bundle exec rspec`