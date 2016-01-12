defmodule Counter do
  # API methods
  def new do
    spawn fn -> loop(0) end
  end

  def set(pid, value) do
    send(pid, {:set, value, self()})
    receive do x -> x end
  end

  def click(pid) do
    send(pid, {:click, self()})
    receive do x -> x end
  end

  def get(pid) do
    send(pid, {:get, self()})
    receive do x -> x end
  end

  # Counter implementation
  defp loop(n) do
    receive do
      {:click, from} ->
        send(from, n + 1)
        loop(n + 1)
      {:get, from} ->
        send(from, n)
        loop(n)
      {:set, value, from} ->
        send(from, :ok)
        loop(value)
    end
  end
end

c = Counter.new
Counter.click(c)
Counter.get(c)
Counter.click(c)
Counter.click(c)
Counter.get(c)


some_post.set_name "Test"

Models.Post.set_name(some_post, "Test")
