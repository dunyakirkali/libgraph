defmodule UndirectedTest do
  use ExUnit.Case, async: true

  describe "reachable/2" do
    test "includes all vertices in connected component" do
      graph =
        Graph.new(type: :undirected)
        |> Graph.add_edges([
          {:a, :b},
          {:b, :c}
        ])

      assert Enum.sort(Graph.Undirected.reachable(graph, [:a])) == [:a, :b, :c]
    end

    test "handles multiple starting vertices" do
      graph =
        Graph.new(type: :undirected)
        |> Graph.add_edges([
          {:a, :b},
          {:c, :d}
        ])

      assert Enum.sort(Graph.Undirected.reachable(graph, [:a, :c])) == [:a, :b, :c, :d]
    end

    test "returns only starting vertex if isolated" do
      graph =
        Graph.new(type: :undirected)
        |> Graph.add_vertex(:a)
        |> Graph.add_vertex(:b)

      assert Graph.Undirected.reachable(graph, [:a]) == [:a]
    end

    test "handles empty starting set" do
      graph =
        Graph.new(type: :undirected)
        |> Graph.add_vertex(:a)

      assert Graph.Undirected.reachable(graph, []) == []
    end

    test "handles multiple components" do
      graph =
        Graph.new(type: :undirected)
        |> Graph.add_edges([
          {:a, :b},
          {:b, :c},
          {:d, :e}
        ])

      result =
        Graph.vertices(graph)
        |> Enum.map(fn vertex ->
          graph
          |> Graph.Undirected.reachable([vertex])
          |> Enum.sort()
        end)

      assert result == [
               [:a, :b, :c],
               [:a, :b, :c],
               [:a, :b, :c],
               [:d, :e],
               [:d, :e]
             ]
    end
  end
end
