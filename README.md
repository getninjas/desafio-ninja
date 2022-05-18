# Desafio Ninja

Solução: Foi criado 2 modelos, uma para sala de reunioes (Meeting Room) e outro para agendamento (Scheduling). O agendamento pode ser realizado enviando os seguintes paramentros:

```json
{
    "meeting_room_id": 1,
    "time": "2022-05-18T10:00:00.000-03:00",
    "responsible": "Nathan"
}
```

### **Observações**
- Cada solicitação corresponde a 1h de agendamento da sala
- Agendamentos não podem ser realizados em tempo anterior ao tempo atual
- Agendamentos não podem ser realizados fora de horario comercial
- Agendamentos não podem ser realizados em periodo ja agendado na mesma sala

Alem das rotas `INDEX, CREATE, UPDATE, SHOW e DESTROY` para agendamento, existe um `INDEX` para obter as salas de reunioes. Todas as rotas estão na [documentação postman](https://documenter.getpostman.com/view/8120581/Uyxkm6AC).

## Configuração Docker Compose

```docker
docker-compose build
```

```docker
docker-compose run api rake db:create db:migrate db:seed
```

```docker
docker-compose up 
```

## Executar testes
```docker
docker-compose run api cucumber
```