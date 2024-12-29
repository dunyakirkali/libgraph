defmodule ReachableTest do
  use ExUnit.Case, async: true

  test "reachable in undirected graph" do
    graph =
      Graph.new(type: :undirected)
      |> Graph.add_edges([
        {:a, :b},
        {:b, :c},
        # Separate component
        {:d, :e}
      ])

    result =
      Graph.vertices(graph)
      |> Enum.map(fn vertex ->
        Graph.reachable(graph, [vertex]) |> Enum.sort()
      end)
      |> Enum.uniq()

    assert result == [
             [:a, :b, :c],
             [:a, :b, :c],
             [:a, :b, :c],
             [:d, :e],
             [:d, :e]
           ]
  end
end
