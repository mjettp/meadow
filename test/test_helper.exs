ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Meadow.Repo, :manual)

Mox.defmock(Meadow.ExAwsHttpMock, for: ExAws.Request.HttpClient)
