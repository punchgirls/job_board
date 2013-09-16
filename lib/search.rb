module Search
  def self.posts(params)
    location = params["location"]
    remote = params["remote"]
    tags = params["tags"].dup.split(",")

    result = Post.find(tag: tags.pop)

    tags.each do |tag|
      result = result.union(tag: tag)
    end

    if !location.empty?
      result = result.find(location: location).union(remote: remote)
    elsif remote
      result = result.find(remote: remote)
    end

    return result
  end
end
