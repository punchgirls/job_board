module Location
  def self.count(posts)
    locations = []

    posts.each do |post|
      locations << post.location
      if post.remote == "true"
        locations << "Work from anywhere"
      end
    end

    occurences = Hash.new(0)

    locations.each do |location|
      occurences[location] += 1
    end

    return occurences
  end
end
