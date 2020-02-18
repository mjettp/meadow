defmodule Meadow.ConfigTest do
  use ExUnit.Case
  alias Meadow.Config
  import Assertions

  test "index_interval/0" do
    assert Config.index_interval() == 1234
  end

  test "ingest_bucket" do
    assert Config.ingest_bucket() == "test-ingest"
  end

  test "preservation_bucket" do
    assert Config.preservation_bucket() == "test-preservation"
  end

  test "upload_bucket" do
    assert Config.upload_bucket() == "test-uploads"
  end

  test "pyramid_bucket" do
    assert Config.pyramid_bucket() == "test-pyramids"
  end

  test "pyramid_processor" do
    assert Path.basename(Config.pyramid_processor()) == "cli.js"
  end

  test "buckets" do
    ["test-ingest", "test-preservation", "test-uploads", "test-pyramids"]
    |> assert_lists_equal(Config.buckets())
  end

  test "test_mode?" do
    assert Config.test_mode?() == true
  end

  test "s3_environment" do
    get_val = fn env, key ->
      env
      |> Enum.find_value(fn
        {^key, v} -> v
        _ -> nil
      end)
    end

    with env <- Config.s3_environment() do
      assert env |> get_val.('AWS_REGION') == 'us-east-1'
      assert env |> get_val.('AWS_SECRET_ACCESS_KEY') == 'minio123'
      assert env |> get_val.('AWS_ACCESS_KEY_ID') == 'minio'
      assert env |> get_val.('AWS_S3_ENDPOINT') |> Enum.slice(0..16) == 'http://localhost:'
    end
  end
end
