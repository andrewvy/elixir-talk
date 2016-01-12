defmodule DistributedPizza.Chef do
  use GenServer

  # PUBLIC API

  @doc """
    Hires a new chef process.
  """
  def hire(model \\ %Pizza{}) do
    GenServer.start_link(__MODULE__, model)
  end

  @doc """
    Gets the pizza.

    Returns `pizza`.
  """
  def get_pizza(pid) do
    GenServer.call(pid, :get_pizza)
  end

  @doc """
    Bakes the pizza. Subsequent bakes will have no effect.

    Returns `{:ok, pizza}`. `{:error, error_message}` otherwise.
  """
  def bake_pizza(pid) do
    GenServer.call(pid, :bake_pizza)
  end

  @doc """
    Adds the ingredient to the pizza.

    Returns `:ok`.
  """
  def add_ingredient(pid, ingredient) do
    GenServer.cast(pid, {:add_ingredient, ingredient})
  end

  # Server Callbacks
  def handle_call(:get_pizza, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:bake_pizza, _from, state) do
    case state.baked do
      True ->
        {:reply, {:ok, state}, state}
      False ->
        new_state = %Pizza{ingredients: state.ingredients, baked: True}
        {:reply, {:ok, new_state}, new_state}
      _ ->
        {:reply, {:error, "Pizza is in a indeterminate state"}, state}
    end
  end

  def handle_cast({:add_ingredient, ingredient}, state) do
    {:noreply, %Pizza{ ingredients: [ingredient | state.ingredients], baked: state.baked }}
  end
end
