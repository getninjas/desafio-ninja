FROM ruby:3.0.2

RUN useradd -ms /bin/bash user

RUN apt-get update -qq && apt-get install -y build-essential postgresql-client libpq-dev

ENV APP_HOME /desafio-ninja
RUN mkdir $APP_HOME

RUN chown user $APP_HOME
USER user

WORKDIR $APP_HOME

ADD . $APP_HOME

RUN bundle install
ENTRYPOINT ["sh", "./entrypoint.sh"]
EXPOSE 3001

CMD ["rails", "server", "-b", "0.0.0.0"]

