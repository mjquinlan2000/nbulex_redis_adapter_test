FROM hexpm/elixir:1.14.4-erlang-25.3-debian-buster-20230227-slim AS builder

RUN mix local.hex --force && \
    mix local.rebar --force && \
    apt-get update && \
    apt-get install -y git

COPY . /build

WORKDIR /build

ENV MIX_ENV=prod

RUN mix deps.get --only prod && \
    mix release

FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y libcrypto++6 libssl1.1

COPY --from=builder /build/_build/prod/rel/redix_test /opt

WORKDIR /opt

CMD ["/opt/bin/redix_test", "start"]