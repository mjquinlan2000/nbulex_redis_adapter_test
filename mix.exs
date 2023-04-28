defmodule RedixTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :redix_test,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RedixTest.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nebulex, "~> 2.4"},
      {:nebulex_redis_adapter, git: "https://github.com/cabol/nebulex_redis_adapter"}
    ]
  end
end
