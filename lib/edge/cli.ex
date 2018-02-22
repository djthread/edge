defmodule Edge.CLI do
  @optionparser_opts [
    strict: [layout: :integer],
    aliases: [l: :layout]
  ]

  @defaults [layout: 1]

  def main(argv \\ []) do
    {cmd, args} = List.pop_at(argv, 0)
    do_run(cmd, OptionParser.parse(args, @optionparser_opts))
  end

  def do_run(cmd, opts) when cmd in ~w(i install) do
    layout = opt(opts, :layout)
    Edge.install(layout)
  end

  def do_run(cmd, opts) when cmd in ~w(c cheat) do
    layout = opt(opts, :layout)
    Edge.cheat(layout)
  end

  def do_run(cmd, opts) do
    raise "Shrugging at cmd #{inspect(cmd)}, #{inspect(opts)}"
  end

  def opt(opts, key) do
    opts |> elem(0) |> Keyword.get(key) || @defaults[key]
  end
end
