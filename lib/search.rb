module Search
  def self.tags(tags)
    posts = []

    tags = tags.split(",")

    tags.each do |tag|
      Post.find(:tag => tag).each do |post|
        posts << post
      end
    end

    posts.uniq!

    return posts
  end
end
