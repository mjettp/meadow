# In this file, we load production configuration and
# secrets from environment variables. You can also
# hardcode secrets, although such is generally not
# recommended and you have to remember to add this
# file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :meadow, Meadow.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :meadow, MeadowWeb.Endpoint,
  url: [host: {:system, "MEADOW_HOSTNAME"}, port: {:system, "PORT"}],
  http: [:inet6, port: {:system, "PORT"}],
  secret_key_base: secret_key_base

ingest_bucket =
  System.get_env("INGEST_BUCKET") ||
    raise """
    environment variable INGEST_BUCKET is missing.
    For example: 'meadow-ingest'
    """

config :meadow, ingest_bucket: ingest_bucket

upload_bucket =
  System.get_env("UPLOAD_BUCKET") ||
    raise """
    environment variable UPLOAD_BUCKET is missing.
    For example: 'meadow-uploads'
    """

config :meadow, upload_bucket: upload_bucket
