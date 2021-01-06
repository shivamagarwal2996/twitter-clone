defmodule ExpWeb.RoomChannel do

  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  # def join("room:" <> private_room_id, _params, socket) do
  #   {:error, %{reason: "unauthorized"}}
  # end

  def handle_in(topic, message, socket) do
    case topic do
      "get_blocks" ->
        # Project4.getUsers(:orchestrator)
        # response = Project4.getUsers(:orchestrator)
        response = Project4.getMessages(:orchestrator)
        IO.inspect response
        {:reply, {:ok, response}, socket}
      "get_users" ->
        # Project4.getUsers(:orchestrator)
        response = Project4.getUsers(:orchestrator)
        # response = Project4.getMessages(:orchestrator)
        IO.inspect response
        {:reply, {:ok, response}, socket}
      "get_messages" ->
        block_height = message["blockHeight"]
        IO.puts "handle_in #{block_height}"
        response = Bitcoind.get_block_by_height(:bitcoind, block_height)
        IO.inspect response
        {:reply, {:ok, response}, socket}
      "get_blocks_meta" ->
        IO.puts "get_blocks_meta"
        response = %{
          blocks: Bitcoind.get_blocks_meta(:bitcoind)
        }
        IO.inspect response;
        {:reply, {:ok, response}, socket}
    end
  end


  def spam(height, timestamp, num_txns, nonce, amount) do
    ExpWeb.Endpoint.broadcast! "room:lobby", "new_block", %{
      height: height,
      age: timestamp,
      num_txns: num_txns,
      amount: amount,
      nonce: nonce
    }
  end
end
