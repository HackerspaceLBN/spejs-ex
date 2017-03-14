FROM elixir:1.4-slim

RUN apt-get update -q && \
    apt-get -y install \
    curl libpq-dev inotify-tools build-essential git apt-utils \
    && apt-get clean -y && \
    rm -rf /var/cache/apt/*

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash && \
    apt-get install -y nodejs

WORKDIR /application

COPY mix.* /application/
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.info && \
    mix deps.get && \
    mix deps.compile

COPY assets/package.json /application/assets/package.json
RUN cd assets && \
    npm install --loglevel error && \
    cd ..

WORKDIR /application
ADD . /application

RUN mix compile
