defmodule Participant do
  use GenServer

  def start_link(args) do
    {id, name, sid, numUsers} = args
    res = GenServer.start_link(__MODULE__, args, [])
    {a, pid} = res
    Server.addUser(sid, {name, pid})
    res
  end

  def sendMessage(participant, count) do
    GenServer.cast(participant, {:send, count})
  end

  def receiveMessage(participant, message) do
    GenServer.cast(participant, {:receive, message})
  end

  def randomSubscribe(participant, number) do
    GenServer.cast(participant, {:subs, number})
  end

  # Server APIs
  def init(args) do
    {id, name, sid, numUsers} = args
    {:ok,
     %{
       :id => id,
       :name => name,
       :sid => sid,
       :numUsers => numUsers
     }}
  end

  def handle_cast(arg1, state) do
    {method, methodArgs} = arg1

    case method do
      :send ->
        sendM(state, methodArgs)
        # newState = put_in(state.route, route)
        # newState = put_in(newState.pidmap, pidmap)
        {:noreply, state}
      :receive ->
        # route = Initialize.initializeRoute(actorsList, state.index)
        # # IO.puts(route)
        # newState = put_in(state.route, route)
        # newState = put_in(newState.pidmap, pidmap)
        {:noreply, state}
      :subs ->
        Enum.map(1..methodArgs, fn (x) -> Server.subscribe(state.sid, state.name) end)
        {:noreply, state}
    end
  end

  def sendM(state, count) do
    if count > 0 do
      Server.receiveMessage(state.sid, {state.name, StringGenerator.random_string(20)})
      Process.send_after(self(), {:send, count-1}, 5000)
    end
  end

  def handle_info(arg1, state) do
    {method, methodArgs} = arg1

    case method do
      :send ->
        sendM(state, methodArgs)
        # newState = put_in(state.route, route)
        # newState = put_in(newState.pidmap, pidmap)
        {:noreply, state}
    end
  end

  def retweet(message, state) do
    Server.receiveMessage(state.sid, {state.name, message})
  end
end
