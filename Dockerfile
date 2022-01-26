FROM ruby:3.0.0

# Diretorio de trabalho
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
VOLUME /usr/src/app

# install rails dependencies
RUN apt update
RUN apt install -y git libxml2 libxml2-dev libxslt1-dev pkgconf
RUN apt install -y postgresql-client


# Copia todos os arquivos da pasta para o diretorio de trabalho
COPY Gemfile Gemfile.lock /usr/src/app/

RUN bundle install
ADD . /usr/src/app
