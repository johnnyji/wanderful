class SearchByPost
  extend Service
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def call
    search_results = Post.search(@query).order("created_at DESC")
    query_name = "Posts about <span class='query-name'>#{query}</span>".html_safe

    [ query_name, search_results ]
  end
end