module Search
  def self.tags(_tags)
    tags = _tags.dup.split(",")

    posts = Post.find(tag: tags.pop)

    tags.each do |tag|
        posts = posts.union(tag: tag)
    end

    return posts
  end
end
