defmodule MeadowWeb.SubscriptionCase do
  @moduledoc """
  Test case for testing Absinthe Subscriptions.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest

      use MeadowWeb.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
        schema: MeadowWeb.Schema.Schema

      import Meadow.TestHelpers

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(MeadowWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket}
      end
    end
  end
end
