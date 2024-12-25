defmodule UndirectedTest do
  use ExUnit.Case, async: true

  def neighbors({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1}
    ]
  end

  def to_graph(map) do
    map
    |> Enum.reduce(Graph.new(type: :undirected), fn {pos, plant}, g ->
      pos
      |> neighbors()
      |> Enum.reduce(Graph.add_vertex(g, pos, plant), fn npos, gg ->
        nchar = Map.get(map, npos, "#")

        if nchar == plant do
          Graph.add_edge(gg, pos, npos)
        else
          gg
        end
      end)
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, col}, accc ->
        Map.put(accc, {col, row}, char)
      end)
    end)
  end

  test "failing case" do
    graph =
      Path.join([__DIR__, "fixtures", "day12.txt"])
      |> input()
      |> to_graph()

    result =
      graph
      |> Graph.vertices()
      |> Enum.map(fn vertex ->
        Graph.reachable(graph, [vertex])
        |> Enum.sort()
      end)
      |> Enum.uniq()

    assert result == [
             [{2, 1}, {2, 2}, {3, 2}, {3, 3}],
             [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
             [{0, 1}, {0, 2}, {1, 1}, {1, 2}],
             [{0, 3}, {1, 3}, {2, 3}],
             [{3, 1}]
           ]
  end
end
