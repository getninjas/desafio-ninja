# API - Agenda de reuniões Ninja
> Api projetada para controle de agenda de reuniões.

O projeto se trata de uma API pronta para requisições de agendamento de reuniões. A estrutura do projeto consta de uma Organização com dados de horário comercial e permissão de trabalho em finais de semana. Isso permite que o modelo seja extendido para quaisquer horários comercials e também customização se necessário trabalhar em finais de semana. 
<br>
Por seguinte, Organizações(ou sedes) também possuem a informações de quantas salas possuem, isso também permite que a lógica seja extendida para caso o número de salas aumente. O método #Create de salas depende diretamente do parametro de quantas salas existem em cada organização. Por fim, cada sala pode ter N reuniões, respeitando as regras estipuladas de horário comercial e trabalhos em finais de semana e também demais verificações de horário e agendamentos.

![](./GetReunioes.png)

## Instalação

Para buildar os containers:

```sh
docker-compose build

```
Para entrar no bash e executar os comandos dentro do container:

```sh
docker-compose run --service-ports rails bash

```
Dentro do bash, é possível utilizar os comando de rails db:"etc" mas pode-se utilizar o comando abaixo para realizar as tarefas de DB:

```sh
bin/setup

```

Para iniciar o local host utilizando o IP de rede, utilizar o comando:

```sh
rails s -b 0.0.0.0

```

Para rodar os testes automatizados, utilizar o comando abaixo dentro do bash:

```sh
bundle exec rspec

```

## Exemplo de uso

O db inicial já estará populado com a Sede "São Paulo" e com o número de salas informadas. Para receber o index de todas as salas, utilizar:

```sh
GET localhost:3000/api/v1/organizations/1/rooms

```

_Para mais exemplos, consulte a [Wiki] "Em andamento" 

## Informações do desenvolvedor

[Milles Dyson Schroeder](https://www.linkedin.com/in/milles-schroeder-85144b14b/) – milles.schroeder@gmail.com

[https://github.com/MillesDyson](https://github.com/MillesDyson)