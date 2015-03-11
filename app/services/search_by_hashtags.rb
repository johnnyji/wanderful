class SearchByHashtags
  extend Service
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def call
    query.slice!(0)
    search_results = Post.tagged_with(query).order("created_at DESC")
    query_name = "<span class='query-name'>##{query}</span>".html_safe

    [ query_name, search_results ]
  end
end