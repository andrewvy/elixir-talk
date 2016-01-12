defmodule DistributedPizza.Portal do
  use GenServer

  # PUBLIC API

  @doc """
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @doc """
    Inspects the portal's store.

    Returns `{:ok, pizza_array}`.
  """
  def inspect_store(pid) do
    GenServer.call(pid, :inspect_store)
  end

  @doc """
    Adds to the portal store.
  """
  def store_pizza(pid, pizza) do
    GenServer.cast(pid, {:store_pizza, pizza})
  end

  @doc """
    Pops pizza from the store.

    Returns `{:ok, pizza}`. `:error` otherwise.
  """
  def pop_pizza(pid) do
    GenServer.call(pid, :pop_pizza)
  end

  @doc """
    Delivers a pizza from left's store to right's store.

    Returns `:ok`. `:error` otherwise.
  """
  def deliver(left, right) do
    case DistributedPizza.Portal.pop_pizza(left) do
      :error -> :ok
      {:ok, pizza} -> DistributedPizza.Portal.store_pizza(right, pizza)
    end
  end

  # Server Callbacks

  def handle_cast({:store_pizza, pizza}, store) do
    {:noreply, [pizza|store]}
  end

  def handle_call(:pop_pizza, _from, store) do
    case store do
      [] -> :error
      [h|t] -> {:reply, {:ok, h}, t}
    end
  end

  def handle_call(:inspect_store, _from,store) do
    {:reply, store, store}
  end

end
