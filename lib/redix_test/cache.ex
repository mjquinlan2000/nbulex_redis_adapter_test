defmodule RedixTest.Cache do
  use Nebulex.Cache,
    otp_app: :redix_test,
    adapter: NebulexRedisAdapter
end
