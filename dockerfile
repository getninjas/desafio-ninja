FROM ruby:2.6.3
RUN apt-get update && apt-get install -y postgresql-client
WORKDIR /desafio-ninja
ADD Gemfile /desafio-ninja/Gemfile
ADD Gemfile.lock /desafio-ninja/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
