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

#Para rodar o projeto:

Para rodar o projeto é preciso ter instalado a versão 3.0.3 do Ruby e 7.0.0 do Rails.
Assim que ter feito a instalação deles realize os seguintes passos:
- Rode `bundle install`;
- Configure as informações do seu banco de dados;
- Rode `rails db:create`
- Rode `rails db:migrate`
- Rode `rails db:seed`
- E por fim para estartar o projeto rode `rails s`.

# Descrição da solução
- Para solucionar este problema utilizei a versão 3.0.3 do Ruby, juntamente com a versão 7.0.0 do Rails.

- A solução conta com 3 models, user (usuário), room (sala) e schedule (agenda).

- O cadastro do usuário exige apenas o nome, e-mail, senha e senha de confirmação. Um usúario só pode se registrar sem estar logado no sistema, no restante das ações precisa estar logado. A autênticação do usúario foi feita com as gems devise e devise-jwt.

Assim que logado, o usúario pode listar os usuário do sistema e atualizar apenas os seus dados. Ele também pode ver as salas que estão cadastradas no sistema e fazer a reserva delas, listar as reservas, atualizar as reservas na qual ele criou e deletar reservar que ele tenha criado.

# Descrição dos models

