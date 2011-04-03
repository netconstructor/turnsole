module Turnsole

class SearchResultsMode < ThreadIndexMode
  register_keymap do |k|
    k.add :save_search, "Save search", '%'
  end

  def save_search
    name = BufferManager.ask :save_search, "Name this search: "
    return unless name && name !~ /^\s*$/
    name.strip!
    unless SearchManager.valid_name? name
      BufferManager.flash "Not saved: " + SearchManager.name_format_hint
      return
    end
    if SearchManager.all_searches.include? name
      BufferManager.flash "Not saved: \"#{name}\" already exists"
      return
    end
    BufferManager.flash "Search saved as \"#{name}\"" if SearchManager.add name, @query[:text].strip
  end

  ## a proper is_relevant? method requires some way of asking the index
  ## if an in-memory object satisfies a query. i'm not sure how to do
  ## that yet. in the worst case i can make an in-memory index, add
  ## the message, and search against it to see if i have > 0 results,
  ## but that seems pretty insane.

  def self.spawn_from_query context, query
    title = query.length < 20 ? query : query[0 ... 20] + "..."
    mode = SearchResultsMode.new context, query
    context.screen.spawn "search: \"#{title}\"", mode
    mode.load!
  end
end

end
