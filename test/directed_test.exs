defmodule DirectedTest do
  use ExUnit.Case, async: true

  describe "reachable/2" do
    test "returns empty list for empty graph" do
      assert Graph.new() |> Graph.reachable([]) == []
    end

    test "returns starting vertex if no edges" do
      graph = Graph.new() |> Graph.add_vertex(:a)
      assert Graph.reachable(graph, [:a]) == [:a]
    end

    test "returns reachable vertices" do
      graph =
        Graph.new()
        |> Graph.add_edge(:a, :b)
        |> Graph.add_edge(:b, :c)
        |> Graph.add_edge(:d, :e)

      assert Graph.reachable(graph, [:a]) |> Enum.sort() == [:a, :b, :c]
      assert Graph.reachable(graph, [:d]) |> Enum.sort() == [:d, :e]
      assert Graph.reachable(graph, [:a, :d]) |> Enum.sort() == [:a, :b, :c, :d, :e]
    end

    test "handles cycles" do
      graph =
        Graph.new()
        |> Graph.add_edge(:a, :b)
        |> Graph.add_edge(:b, :c)
        |> Graph.add_edge(:c, :a)

      assert Graph.reachable(graph, [:a]) |> Enum.sort() == [:a, :b, :c]
    end
  end
end
