defmodule Meadow.Accounts.UsersTest do
  use Meadow.DataCase
  alias Meadow.Accounts.Users

  @valid_auth %Ueberauth.Auth{
    credentials: %Ueberauth.Auth.Credentials{
      expires: nil,
      expires_at: nil,
      other: %{},
      refresh_token: nil,
      scopes: [],
      secret: nil,
      token: nil,
      token_type: nil
    },
    extra: %Ueberauth.Auth.Extra{
      raw_info: %{
        user: %{
          cn: [
            "alphabet",
            "alphabet,karen goose",
            "karen",
            "alphabet,karen",
            "goose alphabet",
            "goose",
            "karen alphabet",
            "karen goose alphabet"
          ],
          dn: "uid=abc123,ou=people,dc=northwestern,dc=edu",
          givenName: "Karen",
          mail: "abc123@example.com",
          objectClass: ["organizationalPerson", "person", "inetorgperson", "top"],
          sn: "Alphabet",
          uid: "abc123",
          userPassword: "{SSHA}R9k40Y/G1VN9hgGw5UjczPvUW8Y0nVAy4jcfMA=="
        }
      }
    },
    info: %Ueberauth.Auth.Info{
      description: nil,
      email: "abc123@example.com",
      first_name: nil,
      image: nil,
      last_name: nil,
      location: nil,
      name: "Karen Alphabet",
      nickname: "abc123",
      phone: nil,
      urls: %{}
    },
    provider: :openam,
    strategy: Ueberauth.Strategy.OpenAM,
    uid: "abc123"
  }

  test "`user_from_auth` creates the user if it doesn't exist" do
    assert {:ok,
            %{username: "abc123", display_name: "Karen Alphabet", email: "abc123@example.com"}} =
             Users.user_from_auth(@valid_auth)
  end

  test "`user_from_auth` returns an existing user" do
    Users.user_from_auth(@valid_auth)

    assert {:ok,
            %{username: "abc123", display_name: "Karen Alphabet", email: "abc123@example.com"}} =
             Users.user_from_auth(@valid_auth)
  end
end
