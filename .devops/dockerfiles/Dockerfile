FROM ruby:3.0.0-slim

ARG RAILS_ENV
ARG APP_VERSION

ENV RAILS_ENV ${RAILS_ENV}
ENV APP_VERSION ${APP_VERSION}

RUN apt-get update -qq && apt-get install -y libpq-dev libcurl4-openssl-dev build-essential git

WORKDIR /desafio-ninja

COPY Gemfile* /desafio-ninja/

RUN gem install bundler

RUN bundle install

COPY .devops/dockerfiles/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY . /desafio-ninja/

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "bundle", "exec", "puma" ]