defmodule FarmbotExt.MQTT do
  require Logger

  use Tortoise.Handler

  defstruct client_id: "NOT_SET", connection_status: :down, supervisor: nil

  alias FarmbotExt.MQTT.{
    PingHandler,
    TopicSupervisor
  }

  alias __MODULE__, as: State

  def publish(client_id, topic, payload, opts \\ [qos: 0]) do
    IO.puts("Send message to #{inspect(topic)}")
    Tortoise.publish(client_id, topic, payload, opts)
  end

  def init(args) do
    client_id = Keyword.fetch!(args, :client_id)

    opts = [
      client_id: client_id,
      parent: self(),
      username: Keyword.fetch!(args, :username)
    ]

    {:ok, supervisor} = TopicSupervisor.start_link(opts)
    {:ok, %State{client_id: client_id, supervisor: supervisor}}
  end

  def handle_message([_, _, "ping", _] = topic, payload, s) do
    forward_message(PingHandler, {topic, payload})
    {:ok, s}
  end

  # def handle_message([_, _, "from_clients"], _payl, s) do
  #   {:ok, s}
  # end

  # def handle_message([_, _, "ping"], _payl, s) do
  #   {:ok, s}
  # end

  # def handle_message([_, _, "sync"], _payl, s) do
  #   {:ok, s}
  # end

  # def handle_message([_, _, "terminal_input"], _payl, s) do
  #   {:ok, s}
  # end

  def handle_message(_topic, _payl, state) do
    # Logger.debug("⛆⛆⛆⛆ Unhandled MQTT message: " <> inspect({topic, payl}))
    {:ok, state}
  end

  def forward_message(pid, {topic, message}) when is_pid(pid) do
    if Process.alive?(pid), do: send(pid, {:inbound, topic, message})
  end

  def forward_message(nil, msg) do
    Logger.debug("Dropped message: #{inspect(msg)}")
  end

  def forward_message(mod, {topic, message}) do
    forward_message(Process.whereis(mod), {topic, message})
  end

  def terminate(reason, _state) do
    Logger.debug("MQTT Connection Failed: #{inspect(reason)}")
  end

  def connection(status, s), do: {:ok, %{s | connection_status: status}}
  def subscription(_stat, _filter, state), do: {:ok, state}
end
