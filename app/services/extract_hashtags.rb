class ExtractHashtags
  extend Service

  def initialize(selected_post)
    @post = selected_post
  end

  def call
    current_tags = @post.tags
    current_tags.clear if current_tags # clears the tag list
    tags = @post.extract_tags # extracts tags into an array
    tags.each { |tag| @post.tag_list.add(tag) } # adds each tag to the tag list
  end
end