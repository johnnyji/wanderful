class ExtractHashtags
  extend Service

  def initialize(selected_post)
    @post = selected_post
  end

  def call
    update_and_extract_tags
  end

  private

  def update_and_extract_tags
    current_tags = @post.tag_list
    current_tags.remove(current_tags) # clears the tag list
    tags = @post.extract_tags # extracts tags from the edit view description set by the @post.attributes
    tags.each { |tag| @post.tag_list.add(tag) } # adds each tag to the tag list
  end
end