module Search
  def self.posts(tags)
    tags = tags.dup.split(",")

    result = Post.active.find(tag: tags.pop)

    tags.each do |tag|
      result = result.union(tag: tag, published?: true)
    end

    return result
  end
end
