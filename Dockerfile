# Dockerfile development version
FROM ruby:3.0.2 AS meeting_rooms-development

ARG USER_ID
ARG GROUP_ID
#ARG HOST_IP

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn redis

ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH
COPY meeting_rooms/ .
#COPY files/ .
RUN rm -rf node_modules vendor
RUN gem install rails bundler unicorn
RUN bundle install
RUN bundle exec rails webpacker:install
#RUN bundle exec rails g mongoid:config
RUN yarn install
RUN chown -R user:user /opt/app

USER $USER_ID
CMD bundle exec unicorn -c config/unicorn.rb