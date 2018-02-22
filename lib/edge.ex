defmodule Edge do
  @moduledoc """
  Functions to do the things
  """

  @ref_pattern Application.get_env(:edge, :ref_pattern)
  @kbd_pattern Application.get_env(:edge, :kbd_pattern)
  @regex ~r/(?:\{|\[|fn (?:\{|\[)).+$/

  @doc "Install ref to keyboard"
  def install(num) do
    ref = ref_file!(num)
    kbd = kbd_file!(num)

    {macro_count, config} = ref |> File.read!() |> uncomment()

    IO.puts("Installing map #{num} with #{macro_count} macros to #{kbd}")

    File.write!(kbd, config)
  end

  @doc "Print cheat sheet to console"
  def cheat(num) do
    IO.puts("Cheat sheet #{num}:")

    IO.puts(num |> ref_file!() |> File.read!() |> get_comments())
  end

  defp uncomment(file) do
    file
    |> String.split("\n")
    |> Enum.filter(&(not String.starts_with?(&1, "#")))
    |> Enum.reduce({0, []}, fn line, {macro_count, codes} = acc ->
      case Regex.run(@regex, line) do
        nil ->
          acc

        [code | _] ->
          macro_count =
            if String.contains?(code, "{"),
              do: macro_count + 1,
              else: macro_count

          {macro_count, [code | codes]}
      end
    end)
    |> (fn {macro_count, codes} ->
          {macro_count, codes |> Enum.reverse() |> Enum.join("\n")}
        end).()
  end

  defp get_comments(file) do
    file
    |> String.split("\n")
    |> Enum.reduce([], fn line, acc ->
      case String.starts_with?(line, "#") do
        true ->
          [line | acc]

        false ->
          case Regex.run(@regex, line) do
            nil ->
              [line | acc]

            [code | _] ->
              comment = line |> String.trim_trailing(code) |> String.trim()

              if byte_size(comment) > 0 do
                [comment | acc]
              else
                acc
              end
          end
      end
    end)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp ref_file!(num) do
    file = @ref_pattern |> Path.expand() |> add_num(num)
    File.exists?(file) || raise "Ref file missing: #{file}"
    file
  end

  defp kbd_file!(num) do
    file = @kbd_pattern |> Path.expand() |> add_num(num)
    File.exists?(file) || raise "Kbd file missing: #{file}"
    file
  end

  defp add_num(pattern, num) do
    String.replace(pattern, "#", to_string(num))
  end
end
