FROM ruby:3.1-slim as jemalloc
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    && wget -O - https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj \
    && cd jemalloc-5.2.1 \
    && ./configure \
    && make \
    && make install

FROM ruby:3.1-slim

COPY --from=jemalloc /usr/local/lib/libjemalloc.so.2 /usr/local/lib/

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

# 引数
# nobodyだと動かないかも
# デフォルト引数いらんかな
ARG APP_NAME
ARG WORKDIR
ARG USER=nobody
ARG USER_ID=65534
ARG GROUP=nobody
ARG GROUP_ID=65534

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    default-libmysqlclient-dev \
    default-mysql-client \
    fontconfig \
    git \
    graphviz \
    jq \
    less \
    openssl \
    tzdata \
    unzip \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log \
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && echo "Asia/Tokyo" > /etc/timezone

WORKDIR $WORKDIR

# railsだけ。rails new で上書き
ADD ./ $WORKDIR
#ADD ./Gemfile* $WORKDIR
#ADD ./Gemfile.lock $WORKDIR/Gemfile.lock

# ローカル環境のIDと合わせたらいいと思う
RUN groupadd --gid $GROUP_ID --system $USER \
    && useradd --uid $USER_ID --gid $GROUP_ID --system --create-home $USER \
    && chown -R $USER:$GROUP $WORKDIR

RUN chown $USER:$GROUP $WORKDIR/*

USER $USER

RUN bundle install

# docker-composeで使うからCMDなし
