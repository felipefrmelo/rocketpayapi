FROM elixir:1.9.0-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git python

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

ENV DATABASE_URL=postgres://jhgyflxggdzdnx:b0afee3c2f93a3c2e722d0e80b450763b3986455ee73a687635453b74ab243ec@ec2-54-90-55-211.compute-1.amazonaws.com:5432/d14kkm6dsvec84
ENV SECRET_KEY_BASE=DtDOksUeWVvBIAHwMHe9bLvGaMGvzuccpxRw0W16/vBrZ3XDH7bkykiWcZON9SgC
# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/my_app ./

ENV HOME=/app

CMD ["bin/my_app", "start"]