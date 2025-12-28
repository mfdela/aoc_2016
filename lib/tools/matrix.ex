defmodule Aoc.Tools.Matrix do
  def transpose(matrix) do
    matrix
    |> Enum.zip_with(& &1)
  end
end
