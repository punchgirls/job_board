module Search
  def self.skills(skills)
    posts = []

    skills.each do |skill|
      Post.find(:tag => skill).each do |post|
        posts << post
      end
    end

    return posts.uniq!
  end
end
