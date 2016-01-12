defmodule ChefTest do
  use ExUnit.Case

  test "can hire chef" do
    {:ok, chef} = DistributedPizza.Chef.hire()
    assert chef, "Could not hire chef."
  end

  test "can create pizza" do
    {:ok, chef} = DistributedPizza.Chef.hire()
    %Pizza{ ingredients: ingredients, baked: baked } = DistributedPizza.Chef.get_pizza(chef)

    assert ingredients == [] and baked == False, "Could not get pizza from chef."
  end

  test "can bake pizza" do
    {:ok, chef} = DistributedPizza.Chef.hire()
    {:ok, pizza} = DistributedPizza.Chef.bake_pizza(chef)

    assert pizza.baked == True, "Could not bake pizza."
  end

  test "can add ingredients to pizza" do
    {:ok, chef} = DistributedPizza.Chef.hire()
    :ok = DistributedPizza.Chef.add_ingredient(chef, "Dough");
    :ok = DistributedPizza.Chef.add_ingredient(chef, "White Sauce");
    :ok = DistributedPizza.Chef.add_ingredient(chef, "Parmesan Cheese");
    :ok = DistributedPizza.Chef.add_ingredient(chef, "Chicken");

    {:ok, pizza} = DistributedPizza.Chef.bake_pizza(chef)

    assert pizza.ingredients == ["Chicken", "Parmesan Cheese", "White Sauce", "Dough"], "Could not add ingredients to pizza."
  end
end
