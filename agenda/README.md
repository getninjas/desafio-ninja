# Agenda

Uma API elixir utilizando o phoenix framework para fazer agendamentos de reuniões.

## Libraries used

* [Calendar](https://github.com/lau/calendar)

## Começando

Para iniciar o Phoenix server:
  * Instale as dependências com `mix deps.get`
  * Crie e e faça a migração do seu banco de dados com `mix ecto.setup`
  * Execute `mix phx.server`

 ## REQUEST
  Usando um cliente de api como o Insomnia ou Postman, faça o seguinte request:

  ### Para verificar os horários existentes

  #### GET  
  `localhost:4000/api/scheduler`

  ### Para deletar algum horário existente

  #### DELETE

  `localhost:4000/api/scheduler/<título_da_agenda>`

  ### Para alterar algum título existente

  #### PUT

  `localhost:4000/api/scheduler/edit/<título_da_agenda>`

  ```JSON
  {
    "title": "string"
  }
  ```

  ### Para criar um horário na agenda
  `localhost:4000/api/scheduler`

  #### POST

  ```JSON
{
	"schedule":
	[
		{
      "title": "title",
			"rooms_id": 2,
			"date":
				{
						"day": 3,
						"month": 12,
						"year": 2021
				},
				"time":
				{
						"start": 
						{
							"hours": "16",
							"minutes": "40"
						},
						"end":
						{
							"hours": "17",
							"minutes": "30"
						} 
				}
		}
	]
}
```

  ### Cuidado
  Não é possível criar duas agendas com o mesmo nome
  ### Required fields
 Caso algum campo obrigatório esteja faltando, seja inválido ou nulo a aplicação não será executada

  ### Schedule

`rooms_id`: a sala na qual seá agendado(1-4)

`date`: dia, mês e ano(apenas dias de semana)

`time`: horas e minutos do agendamento

  ### RESPONSE

  ```JSON
{
  "title": "string",
  "rooms_id": "integer",
  "date": {
    "day": "integer",
    "month": "integer",
    "year": "integer"
  },
  "time": {
    "end": {
      "hours": "string",
      "minutes": "string"
    },
    "start": {
      "hours": "string",
      "minutes": "string"
    }
  }
}
```

## Utilizando docker

 ### Configurações
  Na pasta config/dev, altere o hostname para 'db'
  crie o banco de dados e rode as migrações com 'docker-compose run --rm app mix ecto.setup'
  após isso basta executar docker-compose up --build

## Veja mais

  * Site official: https://www.phoenixframework.org/
  * Guias: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Fórum: https://elixirforum.com/c/phoenix-forum
  * Fonte: https://github.com/phoenixframework/phoenix
