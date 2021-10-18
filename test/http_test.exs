defmodule FarmbotTelemetry.HTTPTest do
  use ExUnit.Case
  doctest FarmbotTelemetry.HTTP
  alias FarmbotTelemetry.HTTP

  def get(url) do
    FarmbotTelemetry.HTTP.request(:get, {to_charlist(url), []}, [], [])
  end

  @bad_urls [
    "https://expired.badssl.com/",
    "https://wrong.host.badssl.com/",
    "https://self-signed.badssl.com/"
  ]

  test "request/4 - SSL stuff" do
    case get("https://badssl.com") do
      {:ok, _} -> Enum.map(@bad_urls, fn url -> {:error, _} = get(url) end)
      _ -> IO.warn("Can't reach https://badssl.com; Not testing SSL parts.")
    end
  end

  test "request/4" do
    params = {'http://typo.farm.bot', []}
    assert {:error, _error} = HTTP.request(:head, params, [], [])
  end
end
