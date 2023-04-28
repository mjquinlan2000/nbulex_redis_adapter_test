import Config

config :redix_test, RedixTest.Cache,
  mode: :redis_cluster,
  conn_opts: [host: "redis-cluster"]
