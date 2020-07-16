ExUnit.start(capture_log: true, exclude: [manual: true])
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(Meadow.Repo, :manual)
Authoritex.Mock.init()
ExUnit.after_suite(fn _ -> Meadow.S3Case.show_cleanup_warnings() end)
