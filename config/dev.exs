use Mix.Config

# Configure your database
config :meadow, Meadow.Repo,
  username: "docker",
  password: "d0ck3r",
  database: "meadow_dev",
  hostname: "localhost",
  port: 5433,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :meadow, MeadowWeb.Endpoint,
  http: [port: 3000],
  debug_errors: false,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :meadow, Meadow.ElasticsearchCluster,
  url: System.get_env("ELASTICSEARCH_URL", "http://localhost:9201")

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :meadow, MeadowWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/meadow_web/{live,views}/.*(ex)$",
      ~r"lib/meadow_web/templates/.*(eex)$"
    ]
  ]

config :meadow,
  ingest_bucket: "dev-ingest",
  upload_bucket: "dev-uploads",
  preservation_bucket: "dev-preservation",
  pyramid_bucket: "dev-pyramids"

config :ex_aws,
  access_key_id: "fake",
  secret_access_key: "fake"

config :ex_aws, :s3,
  access_key_id: "minio",
  secret_access_key: "minio123",
  host: "localhost",
  port: 9001,
  scheme: "http://",
  region: "us-east-1"

config :ex_aws, :sqs,
  host: "localhost",
  port: 4101,
  scheme: "http://",
  region: "us-east-1"

config :ex_aws, :sns,
  host: "localhost",
  port: 4101,
  scheme: "http://",
  region: "us-east-1"

config :exldap, :settings,
  server: System.get_env("LDAP_SERVER", "localhost"),
  base: System.get_env("LDAP_BASE_DN", "DC=library,DC=northwestern,DC=edu"),
  port: String.to_integer(System.get_env("LDAP_PORT", "390")),
  user_dn:
    System.get_env("LDAP_BIND_DN", "cn=Administrator,cn=Users,dc=library,dc=northwestern,dc=edu"),
  password: System.get_env("LDAP_BIND_PASSWORD", "d0ck3rAdm1n!"),
  ssl: System.get_env("LDAP_SSL", "false") == "true"

# Do not include metadata nor timestamps in development logs
config :logger, :console,
  format: "$metadata[$level] $levelpad$message\n",
  metadata: [:action]

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
