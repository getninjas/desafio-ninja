# Para rodar o projeto:

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

- User:
 o model do usuário contém o nome, e-mail, mas para cadastrar é preciso informar além do nome e e-mail a senha e a senha de confirmação.

- Room:
 o model da sala contém a descrição da sala e um número.
 
 - Schedule:
 O model da agenda contém o id do usuário que está fazendo a reserva, o id da sala, data de início(start_time) e data de término (end_time).
 No model do da agenda são feitas inúmeras validações, sendo elas: 
    - validar se end_time é maior que start_time, já que a hora de início não pode ser depois da hora de término;
    - validação do dia, para garantir que a reserva não seja feita nos finais de semana.
    - validação para garantir que a duração da reunião não seja igual a zero.
    - validação do horário da reunião, para que não anteceda ou ultrapasse o horário comercial;
    - valdação para garantir que a reunião inicie e termine no mesmo dia;
    - validação para não reservar um horário que outra pessoa tenha reservado.
    
  Na validação para garantir que não seja reservado uma sala no mesmo horário de outra foi utilizado a ideia de buscar as reservas do dia para uma sala específica e se encontrar alguma verificar uma a uma se o horário de início da futura reserva está dentro do período de duração da reserva encontrada, caso o horário coincida é gerado um erro,  caso não coincida é verificado o horário de término, caso ele coincida um erro também é gerado.
  É possível notar que antes de fazer essas validações dentro do looping a presença do seguinte código: `unless schedule.id == id`, ele é usado para validar na atualização da agenda, caso o id da reserva atualizada é o mesmo encontrado na busca de reservas do dia para está sala ele irá ignorar.


# Informações sobre os testes

Para rodar os testes é preciso rodar o comando `rspec` ou `bundle exec rspec`.

A maioria dos testes se encontra nos models, por isso na maioria dos testes de requests são encontrados poucos testes.

# Informações sobre os endpoints

Dentro da pasta `docs` é possível encontrar tanto as collections como um environment para utilzar no postman.
As collections estão organizadas em pastas, sendo elas:
- > User
- > Room
    -> Schedule
    
Para fazer o login sem criar nenhum usuário é só usar um dos 5 usuários que já estão criados, saõ eles:
- user1@getninja.dev
- user2@getninja.dev
- user3@getninja.dev
- user4@getninja.dev
- user5@getninja.dev

A senhas de todos eles é 12345678.

No projeto já existe as 4 salas criadas.

# Subir com docker-compose

Para subir com o docker-compose rode o seguinte comando:

`sudo docker-compose up`
ou
`docker-compose up`




