# Descrição do Problema
Temos um problema grande com reuniões, elas são muitas e temos poucas salas disponíveis.
Precisamos de uma agenda para nos mantermos sincronizados e esse será seu desafio!
Temos 4 salas e podemos usá-las somente em horário comercial, de segunda a sexta das 09:00 até as 18:00.
Sua tarefa será de criar uma API REST que crie, edite, mostre e delete o agendamento dos horários para que os usuários não se percam ao agendar as salas.

## Resolução
Para solução do problema foi implementada a logica básica de ter 4 salas disponíveis, onde cada sala obedece um horário de agendamento das 09:00 até as 18:00 e com exceção dos finas de semana. Para criar um agendamento em uma sala, é necessário escolher a sala e solicitar o agendamento com a data, o horario inicial e a duração em minutos. Os testes são mais complexos em relação a criação dos agendamentos já que pode haver a indisponibilidade da sala em determinado horário.

- [x] O teste deve ser escrito utilizando Ruby e Ruby on Rails
- [x] Utilize as gems que achar necessário
- [x] Não faça squash dos seus commits, gostamos de acompanhar a evolução gradual da aplicação via commits.
- [x] Estamos avaliando coisas como design, higiene do código, confiabilidade e boas práticas
- [x] Esperamos testes automatizados.
- [x] A aplicação deverá subir com docker-compose
- [x] Crie um README.md descrevendo a sua solução e as issues caso houver
- [x] O desafio pode ser entregue abrindo um pull request ou fazendo um fork do repositório

## Tecnologias e ferramentas utilizadas
<li>Ruby on Rails
<li>MongoDB
<li>Docker
<li>Docker Compose
<li>RSpec
<li>Rubocop


## Instalação

Para realizar a contrução dos containers:
```sh
docker-compose build

```
Depois é necessário montar a base de dados:

```sh
docker-compose run meeting_rooms rails dev:setup

```
A aplicação será acessível pelo seu ip local usando a porta 8020. Ex.: 192.168.15.141:8020 ou localhost:8020.
Para subir a aplicação, utilize:
```sh
docker-compose up

```
Para rodar os testes automatizados, utilizar:

```sh
docker-compose run meeting_rooms rspec spec/requests

```
## Exemplo de uso
O banco de dados já está populado com os dados das 4 salas.

Para consultar todas as salas:
```sh
GET localhost:8020/api/v1/rooms

```

Para consultar os agendamentos de uma sala:
```sh
GET localhost:8020/api/v1/rooms/<id>/schedulings

```

Para consultar uma sala especifica:
```sh
GET localhost:8020/api/v1/rooms/<id>

```
Para criar um agendamento em uma sala:
```sh
POST localhost:8020/api/v1/rooms/<id>/schedulings
{
	"date" : "2021-01-03",
	"time" : "09:31",
	"duration" : "30"
}

```

Para consultar um agendamento em uma sala:
```sh
GET localhost:8020/api/v1/rooms/<room_id>/schedulings/<id>

```

Para atualizar um agendamento em uma sala:
```sh
PATCH localhost:8020/api/v1/rooms/<room_id>/schedulings/<id>
{
	"date" : "2021-01-03",
	"time" : "09:31",
	"duration" : "30"
}

```
