defmodule Project4 do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def startServer(server) do
    GenServer.cast(server, {:server})
  end

  def createUsers(server, numUsers) do
    GenServer.cast(server, {:users, {numUsers}})
  end

  def getUsers(server) do
    GenServer.call(server, {:getusers})
  end

  def getMessages(server) do
    GenServer.call(server, {:getMessages})
  end

  def subscribe(server) do
    GenServer.cast(server, {:subscribe})
  end

  def simulation(server, requests) do
    GenServer.cast(server, {:simulation, requests})
  end

  def record_result(server) do
    GenServer.cast(server, {:record})
  end

  def handle_cast({:record}, state) do
    nodes = state.nodes
    nodes = nodes - 1
    new_state = put_in(state.nodes, nodes)

    # Once all processes have finished computation, the running times of these processes are sent to the daemon
    if(nodes == 0) do
      end_time = Time.utc_now()
      IO.write("Finished. Time taken: ")
      IO.inspect(Time.diff(end_time, state.startTime, :microsecond) / 1_000_000)
      # send(:daemon, {:result, 0})
    end
    # IO.puts(nodes)
    {:noreply, new_state}
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok,
     %{
       :pidmap => %{},
       :nodes => 0,
       :userList => nil,
       :server => nil,
       :startTime => nil
     }}
  end

  def handle_cast({:simulation, methodArgs}, state) do
    startTime = Time.utc_now()
    userList = state.userList
    Enum.map(userList, fn ({_a, x}) -> Participant.sendMessage(x, methodArgs)
      Project4.record_result(:orchestrator) end)
    new_state = put_in(state.startTime, startTime)
    {:noreply, new_state}
  end

  def handle_cast({:server}, state) do
    startServer1(state)
  end

  def handle_cast({:users, numUsers}, state) do
    registerUser(numUsers, state)
  end

  def handle_call({:getMessages}, _from, state) do
    {:reply, Server.getMessages(state.server), state}
  end

  def handle_call({:getusers}, _from, state) do
    IO.puts("vjyvkhvkbvkvbkjvbk")
    blocks = %{"one" => state.userList}
    {:reply, state.pidmap, state}
  end

  def handle_cast({:subscribe}, state) do
    simulateSubscribe(state)
  end

  def registerUser({numUsers}, state) do
    userList = Enum.map(1..numUsers, fn (x) -> Participant.start_link({x, StringGenerator.random_string(12), state.server, numUsers}) end)
    actorsList = Enum.map(1..numUsers, fn (x) -> x end)
    pidmap = Enum.reduce actorsList, %{}, fn x, acc ->
    Map.put(acc, x, StringGenerator.random_string(12))
  end
    new_state = put_in(state.pidmap, pidmap)
    new_state = put_in(new_state.userList, userList)
    new_state = put_in(new_state.nodes, numUsers)
    {:noreply, new_state}
  end

  def startServer1(state) do
    {:ok, server} = Server.start_link([])

    new_state = put_in(state.server, server)
    {:noreply, new_state}
  end

  def simulateSubscribe(state) do
    userList = state.userList
    Enum.map(userList, fn ({_a, x}) -> Participant.randomSubscribe(x, :rand.uniform(state.nodes)) end)
    {:noreply, state}
  end

end

defmodule Sample do
  use Application
  use GenServer

  def start_link(opts) do
    # [users, messages] = System.argv()
    # {users, ""} = Integer.parse(users)
    # {messages, ""} = Integer.parse(messages)
    IO.puts("shahjinsj")
    res = Project4.start_link([])
    {:ok, orchestrator_pid} = res
    Process.register(orchestrator_pid, :orchestrator)
    sim()
    # Process.register(self(), :daemon)
    #
    # Project4.startServer(:orchestrator)
    # Project4.createUsers(:orchestrator, users)
    # Project4.subscribe(:orchestrator)
    # Project4.simulation(:orchestrator, messages)
    # receive do
    #   {:result, result} ->
    #     IO.puts(result)
    # end
    res
  end

  def sim() do
      users = 100
      messages = 5
      # users = 45
      # messages = 60

      Project4.startServer(:orchestrator)
      Project4.createUsers(:orchestrator, users)
      Project4.subscribe(:orchestrator)
      Project4.simulation(:orchestrator, messages)
      receive do
        {:result, result} ->
          IO.puts(result)
      end
  end
end

defmodule StringGenerator do
  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
