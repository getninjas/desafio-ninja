FROM elixir:1.12.2-alpine

RUN mkdir -p /opt/app && \
    chmod -R 777 /opt/app

RUN apk update && \
    apk add inotify-tools git build-base && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY . /app

RUN mix do local.hex --force, local.rebar --force

COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

RUN mix deps.get
RUN mix deps.compile

RUN mix phx.digest

RUN mix compile
RUN mix phx.digest

EXPOSE 4000

CMD ["mix", "phx.server"]