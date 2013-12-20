module Search
  def self.posts(params)
    location = params["location"]
    remote = params["remote"]
    tags = params["tags"].dup.split(",")

    result = Post.active.find(tag: tags.pop)

    tags.each do |tag|
      result = result.union(tag: tag)
    end

    return result
  end
end
