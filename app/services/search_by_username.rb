class SearchByUsername
  extend Service
  attr_reader :query
  
  def initialize(query) # this will take in an argument from the SearchByPrefix class
                        # which takes another argument from the search method in the posts controller
    @query = query
  end

  def call
    query.slice!(0)
    post_user = User.find_by(username: query)

    search_results = if post_user #makes sure that the user exists in the database
                        Post.all.where(user_id: post_user.id).order("created_at DESC")
                     else
                        ""
                     end

    query_name = "Posts by <span class='query-name'>@#{query}</span>".html_safe

    [ query_name, search_results ]
  end
end