# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

ruby 3.0.0
rails 6.1.5
postgres

* Configuration

* Database creation

rails db:create
rails db:migrate

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

# Criar Salas
rails db:seed

# GET /api/schedules - Lista todas reuniões

ex:

[
  {
    "id": 1,
    "title": "teste",
    "start_hour": 14,
    "end_hour": 15,
    "date": "1995-08-16T00:00:00.000Z",
    "room_id": 4,
    "created_at": "2022-04-09T23:37:46.120Z",
    "updated_at": "2022-04-09T23:37:46.120Z"
  },
  {
    "id": 2,
    "title": "teste",
    "start_hour": 2,
    "end_hour": 2,
    "date": "1995-08-16T00:00:00.000Z",
    "room_id": 2,
    "created_at": "2022-04-09T23:38:52.173Z",
    "updated_at": "2022-04-10T22:15:17.991Z"
  }
]

# POST /api/schedules - Cria Uma reunião
corpo da requisição

{
  "title": "teste",
  "room_id": 4,
  "date": "16/08/1995",
  "start_hour": 18,
  "end_hour": 19
}

RESPOSTAS:

resposta :ok

{
  "message": "Reunião Criada",
  "data": {
    "id": 6,
    "title": "teste",
    "start_hour": 22,
    "end_hour": 23,
    "date": "1995-08-16T00:00:00.000Z",
    "room_id": 4,
    "created_at": "2022-04-11T02:57:56.905Z",
    "updated_at": "2022-04-11T02:57:56.905Z"
  }
}

resposta :unprocessable_entity

{
  "error": "Já existe uma reunião marcada neste neste horário."
}

resposta :bad_request

{
  "error": {
    "end_hour": [
      "A hora final da reunião é superior ou igual a hora inicial."
    ]
  }
}

resposta :not_found

{
  "error": "Sala não encontrada."
}

# PUT /api/schedules/:id - Editar uma reunião

corpo da requisição

{
    "title": "teste2"
}

RESPOSTAS:

resposta :ok

{
  "message": "Reunião Editada",
  "data": {
    "id": 6,
    "title": "teste3",
    "start_hour": 22,
    "end_hour": 23,
    "date": "1995-08-16T00:00:00.000Z",
    "room_id": 4,
    "created_at": "2022-04-11T02:57:56.905Z",
    "updated_at": "2022-04-11T03:02:36.672Z"
  }
}

resposta :unprocessable_entity

{
  "error": "Já existe uma reunião marcada neste neste horário."
}

resposta :bad_request

{
  "error": {
    "end_hour": [
      "A hora final da reunião é superior ou igual a hora inicial."
    ]
  }
}

resposta :not_found

{
  "error": "Sala não encontrada."
}

# DELETE /api/schedules/:id - Deletar uma reunião

Ex sucesso:

204 - No Content

resposta :not_found

{
  "error": "Reunião não encontrada."
}
