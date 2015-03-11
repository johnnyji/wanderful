class SearchByPrefix
  extend Service
  attr_reader :query
  
  def initialize(query)
    @query = query.dup
  end

  def call
    if query.start_with? "#"
      SearchByHashtags.call(query) #passes in query, which takes an argument @query from the posts controller
    elsif query.start_with? "@"
      SearchByUsername.call(query)
    else
      SearchByPost.call(query)
    end
  end
end