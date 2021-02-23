FROM hexpm/elixir:1.11.2-erlang-23.1.2-alpine-3.12.1 as deps

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix --mount=type=cache,target=/root/.hex \
    mix deps.get --only $MIX_ENV

FROM node:15.7.0-alpine3.10 as assets

# install build dependencies
RUN mix --mount=type=cache,sharing=locked,target=/var/cache/apk \
    apk add build-base python

# prepare build dir
WORKDIR /app

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
# install all npm dependencies from scratch
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY --from=deps /app/deps ./deps

COPY priv priv


# Note: if your project uses a tool like https://purgecss.com/,
# which customizes asset compilation based on what it finds in
# your Elixir templates, you will need to move the asset compilation step
# down so that `lib` is available.
COPY assets assets
# use webpack to compile npm dependencies - https://www.npmjs.com/package/webpack-deploy
RUN npm run --prefix ./assets deploy

FROM deps as build

# prepare build dir
WORKDIR /app

RUN mkdir config
# Dependencies sometimes use compile-time configuration. Copying
# these compile-time config files before we compile dependencies
# ensures that any relevant config changes will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/$MIX_ENV.exs config/
RUN mix deps.compile

COPY --from=assets /app/priv ./priv
RUN mix phx.digest

# compile and build the release
COPY lib lib
RUN mix compile
# changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix release

# Start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM alpine:3.12.1 AS app
RUN mix --mount=type=cache,sharing=locked,target=/var/cache/apk \
    apk add openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/my_app ./

ENV HOME=/app

ENTRYPOINT ["bin/my_app"]
CMD ["start"]