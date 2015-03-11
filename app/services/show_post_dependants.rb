class ShowPostDependants
  extend Service

  def initialize(selected_post)
    @post = selected_post
  end

  def call
    comments = @post.comments.order("created_at DESC")
    tags = @post.tags
    hashtags = @post.extract_tags
    [ comments, tags, hashtags ]
  end
end