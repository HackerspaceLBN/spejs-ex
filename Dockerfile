FROM elixir:1.4-slim

RUN apt-get update -q && \
    apt-get -y install \
    curl libpq-dev inotify-tools build-essential \
    && apt-get clean -y && \
    rm -rf /var/cache/apt/*

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash && \
    apt-get install -y nodejs

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.info

RUN mix archive.install --force \
  https://github.com/phoenixframework/archives/raw/master/phx_new.ez

WORKDIR /application

COPY mix.* /application/
RUN mix deps.get


COPY assets/package.json /application/assets/package.json
RUN cd assets && \
    npm install --loglevel error && \
    cd .. && \
    mix deps.compile

WORKDIR /application
ADD . /application

RUN mix compile
