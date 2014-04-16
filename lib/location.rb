module Location
  def self.count(posts)
    locations = []
    occurences = Hash.new(0)

    posts.each do |post|
      unless post.location.nil?
        locations << post.location
      end
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
