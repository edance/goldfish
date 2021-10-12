defmodule GoldfishWeb.Helpers.CheckboxHelper do
  use Phoenix.HTML

  # https://dev.to/ricardoruwer/many-to-many-associations-in-elixir-and-phoenix-21pm

  @doc """
  Renders multiple checkboxes.

  ## Example

      iex> multiselect_checkboxes(
             f,
             :tags,
             Enum.map(@tags, fn c -> { c.name, c.id } end),
             selected: Enum.map(@changeset.data.tags,&(&1.id))
           )
      <div class="checkbox">
        <label>
          <input name="page[tags][]" id="page_tags_1" type="checkbox" value="1" checked>
          <input name="page[tags][]" id="page_tags_2" type="checkbox" value="2">
        </label>
      </div
  """
  def multiselect_checkboxes(form, field, options, opts \\ []) do
    {selected, _} = get_selected_values(form, field, opts)
    selected_as_strings = Enum.map(selected, &"#{&1}")

    for {value, key} <- options, into: [] do
      content_tag(:label, class: "checkbox-inline") do
        [
          tag(:input,
            name: input_name(form, field) <> "[]",
            id: input_id(form, field, key),
            type: "checkbox",
            value: key,
            checked: Enum.member?(selected_as_strings, "#{key}")
          ),
          value
        ]
      end
    end
  end

  defp get_selected_values(form, field, opts) do
    {selected, opts} = Keyword.pop(opts, :selected)
    param = field_to_string(field)

    case form do
      %{params: %{^param => sent}} ->
        {sent, opts}

      _ ->
        {selected || input_value(form, field), opts}
    end
  end

  defp field_to_string(field) when is_atom(field), do: Atom.to_string(field)
  defp field_to_string(field) when is_binary(field), do: field
end
