defmodule Meadow.MixProject do
  use Mix.Project

  def project do
    [
      app: :meadow,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.circle": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      releases: [
        meadow: [
          include_executables_for: [:unix],
          applications: [meadow: :permanent, runtime_tools: :permanent]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Meadow.Application, []},
      extra_applications: [:honeybadger, :logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:briefly, "~> 0.3.0", only: :test},
      {:credo, "~> 1.1.1", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.0"},
      {:ecto_ulid, "~> 0.2.0"},
      {:ets, "~> 0.7.3"},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_aws, "~> 2.1"},
      {:excoveralls, "~> 0.10", only: :test},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.9"},
      {:honeybadger, "~> 0.7"},
      {:jason, "~> 1.0"},
      {:mox, "~> 0.5", only: :test},
      {:nimble_csv, "~> 0.6.0"},
      {:open_api_spex, "~> 3.4"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix, "~> 1.4.6"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:sweet_xml, "~> 0.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
