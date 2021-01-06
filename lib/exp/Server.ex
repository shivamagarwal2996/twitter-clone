defmodule Server do
  use Application
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def distributeMessage(participant, message) do
    GenServer.cast(participant, {:distribute, message})
  end

  def receiveMessage(participant, args) do
    GenServer.cast(participant, {:receive, args})
  end

  def addUser(participant, message) do
    GenServer.cast(participant, {:registerUser, message})
  end

  def subscribe(participant, message) do
    GenServer.cast(participant, {:subscribe, message})
  end

  def getMessages(server) do
    GenServer.call(server, {:getMessages})
  end

  # Server APIs
  def init(:ok) do
    {:ok,
     %{
       :route => {},
       :userMap => %{},
       :subMap => %{},
       :userMsg => %{},
       :tagMsg => %{},
       :messages => %{},
     }}
  end

  def handle_call({:getMessages}, _from, state) do
    IO.puts("vjyvkhvkbvkvbkjvbk")
    # blocks = %{"one" => state.userList}
    {:reply, state.messages, state}
  end

  def handle_cast(arg1, state) do
    {method, methodArgs} = arg1

    case method do
      :distribute ->
        {:noreply, state}
      :receive ->
        {name, message} = methodArgs
        distribute(name, message, state)
      :registerUser ->
        {name, pid} = methodArgs
        registerUser(name, pid, state)
      :subscribe ->
        us1 = methodArgs
        subscribe1(us1, state)
    end
  end

  def subscribe1(us1, state) do
    keys = Map.keys(state.userMap)
    us2 = Enum.random(keys)
    subMap = state.subMap
    subscribers = elem(Map.fetch(subMap,us2),1)
    new_subscribers = subscribers++[us1]
    subMap = Map.put(subMap, us2, new_subscribers)
    new_state = put_in(state.subMap, subMap)
    {:noreply, new_state}
  end

  def subscribe1(us1, us2, state) do
    subMap = state.subMap
    subscribers = elem(Map.fetch(subMap,us2),1)
    new_subscribers = subscribers++[us1]
    subMap = Map.put(subMap, us2, new_subscribers)
    new_state = put_in(state.subMap, subMap)
    {:noreply, new_state}
  end

  def registerUser(name, pid, state) do
    userMap = state.userMap
    subMap = state.subMap
    userMap = Map.put(userMap, name, pid)
    subMap = Map.put(subMap, name, [])
    new_state = put_in(state.userMap, userMap)
    new_state = put_in(new_state.subMap, subMap)
    {:noreply, new_state}
  end

  def addUserMsg(name, message, state) do
    userMsg = state.userMsg
    userMsg = Map.put(userMsg, name, message)
    new_state = put_in(state.userMsg, userMsg)
    {:noreply, new_state}
  end

  def addTagMsg(name, message, state) do
    tagMsg = state.tagMsg
    tagMsg = Map.put(tagMsg, name, message)
    new_state = put_in(state.tagMsg, tagMsg)
    {:noreply, new_state}
  end

  def deleteUser(name, state) do
    userMap = state.userMap
    userMap = Map.delete(userMap, name)
    new_state = put_in(state.userMap, userMap)
    {:noreply, new_state}
  end

  def distribute(name, message, state) do
    messages = state.messages
    # messages = Map.put(messages, StringGenerator.random_string(12), "user: "+name+" message: "+message)
    tags = ["#DOSrocks", "#DOSrocks1" , "#DOSrocks2", "#DOSrocks2", "#DOSrocks3"]
    random_number = :rand.uniform(100)
    re = if random_number < 10 do "reTweet" else "" end
    randNumber = :rand.uniform(100)
    tag = if randNumber < 10 do Enum.random(tags) else "" end
    messages = Map.put(messages, StringGenerator.random_string(12), message<> " " <>tag<> "          " <> re)
    subMap = state.subMap
    subscribers = elem(Map.fetch(subMap,name),1)
    Enum.map(subscribers, fn (x) -> sendMessage(x, message, state) end)
    new_state = put_in(state.messages, messages)
    {:noreply, new_state}
  end

  def sendMessage(name ,message, state) do
    # IO.puts(state.userMap)
    userMap = state.userMap
    pid = elem(Map.fetch(userMap,name),1)
    Participant.receiveMessage(pid, message)
  end

  def queryUser(state, name) do
    # IO.puts(state.userMap)
    userMsg = state.userMsg
    # Enum.filter(userMsg, fn (k, x) -> k == name end)
    ["message"]
  end

  def queryTag(state, name) do
    tagMsg = state.tagMsg
    # Enum.filter(tagMsg, fn (k, x) -> k == name end)
    ["COT"]
  end

  def sample() do
    :world
  end



end
