module Location
  def self.count(posts)
    locations = []
    occurences = Hash.new(0)

    posts.each do |post|
      locations << post.location
      if post.remote == "true"
        locations << "Work from anywhere"
      end
    end

    locations.each do |location|
      occurences[location] += 1
    end

    return occurences
  end
end
