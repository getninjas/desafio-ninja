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

### Executando o sistema
Para executar o sistema, rode o comando abaixo na linha de comando

```
docker-compose up
```

Serão criados 4 cointaineres
  - PostgreSQL: banco de dados relacional onde são salvas as entidades do sistema
  - Redis: Banco de dados chave-valor para uso do Redis
  - Sidekiq: Para o envio de emails para os convidados de uma reunião
  - Aplicação: Container onde o servidor rails é executado

### Criando o banco de dados
execute na linha de comando
```
docker-compose exec app bundle e rails db:create
```
para criar um banco de dados chamado getninjas em no PostgreSQL
```
docker-compose exec app bundle e rails db:migrate
```
para criar as tabelas
 - users
 - rooms
 - schedules
 - guests
 - guests_schedules

e por fim, execute

```
docker-compose exec app bundle e rails db:seed
```
para que sejam criados 4 salas de reunião e um usuário

### Interagindo com a aplicação
Assim que os container da aplicação executa, o servidor rails fica disponível no endereço `http://localhost:3000`.
A primeira coisa a ser feita para interagir com a aplicação é criar um token de acesso no endpoint de geração de token
```
POST /auth/token
header: 'Content-Type: application/json'
body: {
  "user_email": "sullyvan@email.com",
  "password": "getninjas"
}
```
O retorno dessa requisição é o token de acesso no formato JWT
```
{
    "data": {
        "access_token": "eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7InVzZXJfaWQiOiI3NDBlNDJmNy1hNGE5LTQ3OWUtYjk0Ni0xODA0ZmNlOGFiNmEifSwiZXhwIjoxNjM2NTQ4MjQwfQ.l8a48i0vJTmFcIfmbK0Yy6s-OGCrwJyYr2EyV1obO7w"
    }
}
```

O token é necessário para interagir com todos os endpoints da aplicação.
Para usa-lo é necessário inclui-lo no header das requisição como:
```
'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7InVzZXJfaWQiOiI3NDBlNDJmNy1hNGE5LTQ3OWUtYjk0Ni0xODA0ZmNlOGFiNmEifSwiZXhwIjoxNjM2NTQ4MjQwfQ.l8a48i0vJTmFcIfmbK0Yy6s-OGCrwJyYr2EyV1obO7w'
```

A aplicação disponibiliza os endpoints

- Listagem de reuniões

request:
```
GET /schedules
```
response:
```
{
    "data": {
        "rooms": [
            {
                "Room#1": [
                    {
                        "start_time": "2021-11-10 00:15:38",
                        "end_time": "2021-11-10 00:15:38"
                    }
                ]
            }
        ]
    }
}
```

- Criação de reunião

request:
```
POST /schedules
{
    "room_name": "Room#3",
    "user_email": "sullyvan@email.com",
    "schedule": {
        "start_time": "2021-11-09 09:30:00",
        "end_time": "2021-11-09 12:00:00"
    },
    "guests": [
        {
            "email": "darwin@email.com"
        }
    ]
}
```

campos:
```
room_name: string (obrigatorio),
user_email: string (obrigatorio),
schedule: Object string (obrigatorio) {
  start_time: DateTime ISO 8601 (obrigatorio),
  end_time: DateTime ISO 8601 (obrigatorio)
},
guests: Array<Object> (Optional) [
  {
    email: string (obrigatorio)
  }
]
```

response:
```
{
    "data": {
        "schedule": {
            "id": "d223aa0e-2ed9-49c2-a0fc-9c8bd3fae30c",
            "start_time": "2021-11-09 09:30:00",
            "end_time": "2021-11-09 12:00:00"
        }
    }
}
```

Quando o campo guests está presente a aplicação vai enviar um email de maneira asíncrona para cada convidado

- Atualização de reunião

request:
```
PUT /schedules/:id
{
  "schedule": {
    "start_time": "2021-12-09 09:30:00",
    "end_time": "2021-12-09 12:00:00"
  }
}
```

campos:
```
schedule: Object string (obrigatorio) {
  start_time: DateTime ISO 8601 (obrigatorio),
  end_time: DateTime ISO 8601 (obrigatorio)
}
```

response:
```
{
  "data": {
    "message": "success"
  }
}
```

- Deleção de reunião

request:
```
DELETE /schedules/:id
```

response:
```
{
  "data": {
    "message": "success"
  }
}
```

## Evitando concorrência
Para evitar que mais de um request concorrent crie mais de uma reunião na mesma sala a aplicação segue a seguinte lógica:

 - Busca na tabela schedules todos os schedules que pertence a sala e ao dia que está tentando criar ou atualizar a reunião
 - É feito um lock para todas as colunas retornadas nessa busca afim de evitar que qualquer outro request possa atualiza-las
 - Somente depois da validação da disponibilidade dos horários que a reunião é criada na tabela schedule
 - Caso haja conflito a aplicação response 422 (Unprocessable Entity)

## Organização do código
A aplicação usa o padrão de projeto Form Object. Todos esses forms são usados como repositorios para fazer interface com a base de dados. Além dos forms foram criados classes de validações customizadas que são usados em dois pontos criticos da aplicação.

## Rodando testes
Para rodas os testes é necessário primeiro criar o banco de dados de testes e rodar suas migrations

execute na linha de comando
```
docker-compose exec app RAILS_ENV=test bundle e rails db:create db:migrate
```

para executar os testes basta então executar
```
docker-compose exec app rspec
```
