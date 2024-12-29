defmodule Graph.Undirected do
  @moduledoc false

  def reachable(%Graph{type: :undirected} = graph, vertices) when is_list(vertices) do
    vertices
    |> collect_reachable(graph, MapSet.new())
    |> MapSet.to_list()
  end

  defp collect_reachable([], _graph, seen), do: seen

  defp collect_reachable([vertex | rest], graph, seen) do
    if MapSet.member?(seen, vertex) do
      collect_reachable(rest, graph, seen)
    else
      new_seen = MapSet.put(seen, vertex)
      neighbors = Graph.neighbors(graph, vertex)
      neighbors_seen = collect_reachable(neighbors, graph, new_seen)
      collect_reachable(rest, graph, neighbors_seen)
    end
  end
end
