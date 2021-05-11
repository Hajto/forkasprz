defmodule MyFirstCredoCheck do
  @moduledoc """
    Checks all lines for a given Regex.

    This is fun!
  """

  @explanation [
    check: @moduledoc,
    params: [
      regex: "All lines matching this Regex will yield an issue."
    ]
  ]
  @default_params [
    # our check will find this line.
    regex: ~r/Creeeedo/
  ]

  use Credo.Check, base_priority: :high, category: :custom

  @doc false
  @impl true
  def run(%SourceFile{} = source_file, params) do
    require Logger
    Logger.info("#{inspect("123")}")

    ast = SourceFile.ast(source_file)

    # IssueMeta helps us pass down both the source_file and params of a check
    # run to the lower levels where issues are created, formatted and returned
    issue_meta = IssueMeta.for(source_file, params)

    {_ast, issues} =
      Macro.prewalk(
        ast,
        [],
        fn
          {{:., _call_context, [{:__aliases__, _, [:Logger]}, :info]}, _, args} = node, acc ->
            issues = add_issues_if_present(args, issue_meta)
            {node, acc ++ issues}

          node, acc ->
            # IO.inspect(node, label: "node")
            {node, acc}
        end
      )

    issues
    |> List.flatten()
  end

  defp add_issues_if_present(args, issue_meta) do
    Enum.flat_map(args, fn arg ->
      {_nodes, acc} = Macro.prewalk(
        arg,
        [],
        fn
          {:inspect, context, _a} = node, acc ->
            issue =
              format_issue(
                issue_meta,
                message: "Inspect in log message",
                line_no: Keyword.fetch!(context, :line),
                column: Keyword.fetch!(context, :column)
              )

            {node, [issue | acc]}

          node, acc ->
            {node, acc}
        end
      )
      acc
    end)
  end
end
