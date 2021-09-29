FROM ruby:3.0.1-alpine

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

ARG APP_NAME
ARG WORKDIR=/$APP_NAME
ARG USER=nobody   # デフォルトnobodyにしたけど権限弱すぎ多分指定しないと無理
ARG USER_ID=65534
ARG GROUP=nobody
ARG GROUP_ID=65534

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        g++ \
        gcc \
        libc-dev \
        libxml2-dev \
        linux-headers \
        make \
        mariadb-dev \
        nodejs \
        tzdata \
        yarn && \
    apk add --virtual build-packs --no-cache \
        build-base \
        curl-dev && \
    apk del build-packs

RUN addgroup -S -g $GROUP_ID $GROUP && \
    adduser -u $USER_ID -G $USER -D $USER

WORKDIR $WORKDIR

#COPY Gemfile $WORKDIR
#COPY Gemfile.lock $WORKDIR

#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]

#RUN gem install rails
#RUN rails new $APP_NAME -d mysql --skip-action-mailbox --skip-active-storage --skip-action-cable -S --skip-spring --skip-system-test --skip-bootsnap --skip-bundle --skip-webpack-install --api
#RUN mv -f $APP_NAME/* .
#RUN bundle install

#COPY . $WORKDIR

#RUN rails db:create db:migrate db:seed

# Add a script to be executed every time the container starts.
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]
#
## Start the main process.
#CMD ["rails", "server", "-b", "0.0.0.0"]
#

# ホスト側（ローカル）のGemfileを追加する（ローカルのGemfileは【３】で作成）
#ADD ./Gemfile $WORKDIR/Gemfile
#ADD ./Gemfile.lock $WORKDIR/Gemfile.lock
#
## Gemfileのbundle install
#RUN bundle install

ADD ./Gemfile $WORKDIR/Gemfile
ADD ./Gemfile.lock $WORKDIR/Gemfile.lock

RUN chown $USER:$GROUP $WORKDIR/*

USER $USER

# Gemfileのbundle install
RUN bundle install

ADD ./ $WORKDIR
