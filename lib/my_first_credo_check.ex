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
    ast = SourceFile.ast(source_file)
    issue_meta = IssueMeta.for(source_file, params)

    do_walk = fn
      {{:., _call_context, [{:__aliases__, _, [:Logger]}, :info]}, _, args} = node, acc ->
        issues = add_issues_if_present(args, issue_meta)
        {node, acc ++ issues}

      node, acc ->
        {node, acc}
    end

    Macro.prewalk(ast, [], do_walk)
    # Extracts acc from prewalk return
    |> elem(1)
    |> List.flatten()
  end

  defp add_issues_if_present(args, issue_meta) do
    do_walk = fn
      {:inspect, context, _a} = node, acc ->
        issue = issue_from_ast_context(context, issue_meta)
        {node, [issue | acc]}

      node, acc ->
        {node, acc}
    end

    Enum.flat_map(args, fn arg ->
      Macro.prewalk(arg, [], do_walk)
      # Extracts acc from prewalk return
      |> elem(1)
    end)
  end

  defp issue_from_ast_context(context, issue_meta) do
    format_issue(issue_meta,
      message: "Inspect in log message",
      line_no: Keyword.fetch!(context, :line),
      column: Keyword.fetch!(context, :column)
    )
  end
end
