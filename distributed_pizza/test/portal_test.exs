defmodule PortalTest do
  use ExUnit.Case

  test "can store pizza" do
    {:ok, chef} = DistributedPizza.Chef.hire()
    {:ok, pizza} = DistributedPizza.Chef.bake_pizza(chef)
    {:ok, portal} = DistributedPizza.Portal.start_link()

    :ok = DistributedPizza.Portal.store_pizza(portal, pizza);

    pizzas = DistributedPizza.Portal.inspect_store(portal)

    assert Enum.count(pizzas) == 1, "Did not store pizza in portal."
  end

  test "can store and pop pizza" do
    {:ok, chef} = DistributedPizza.Chef.hire()
    {:ok, pizza} = DistributedPizza.Chef.bake_pizza(chef)
    {:ok, portal} = DistributedPizza.Portal.start_link()

    :ok = DistributedPizza.Portal.store_pizza(portal, pizza);

    pizzas = DistributedPizza.Portal.inspect_store(portal)
    assert Enum.count(pizzas) == 1, "Did not store pizza in portal."

    {:ok, _popped_pizza} = DistributedPizza.Portal.pop_pizza(portal)

    pizzas = DistributedPizza.Portal.inspect_store(portal)
    assert Enum.count(pizzas) == 0, "Did not pop pizza from the portal."
  end

  test "can deliver a pizza between portals" do
    {:ok, chef} = DistributedPizza.Chef.hire()
    {:ok, pizza} = DistributedPizza.Chef.bake_pizza(chef)
    {:ok, portal} = DistributedPizza.Portal.start_link()
    {:ok, portal2} = DistributedPizza.Portal.start_link()

    :ok = DistributedPizza.Portal.store_pizza(portal, pizza);

    pizzas = DistributedPizza.Portal.inspect_store(portal)
    assert Enum.count(pizzas) == 1, "Did not store pizza in portal."

    :ok = DistributedPizza.Portal.deliver(portal, portal2)

    pizzas = DistributedPizza.Portal.inspect_store(portal)
    assert Enum.count(pizzas) == 0, "Did not pop pizza from the portal."

    pizzas = DistributedPizza.Portal.inspect_store(portal2)
    assert Enum.count(pizzas) == 1, "Did not deliver pizza to the portal."
  end
end
