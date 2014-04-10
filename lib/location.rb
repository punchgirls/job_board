module Location
  def self.count(posts)
    cities = []

    posts.each do |post|
      cities << post.location
      if post.remote == "true"
        cities << "Work from anywhere"
      end
    end

    locations = Hash.new { |k, v| k[v] = 0 }

    cities.each do |location|
      locations[location] += 1
    end

    locations = locations.sort_by { |h| -h[1] }

    return locations
  end
end
