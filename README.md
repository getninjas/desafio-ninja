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

# Instalação
  Docker
  - docker-compose build
  Banco de dados
  - docker-compose run web rake db:drop db:create db:migrate
  Start
  - docker-compose up
  Executar testes
  - docker-compose run web bundle exec rspec

 # Documentação
  http://localhost:3000/apipie
