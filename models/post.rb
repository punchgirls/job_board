class Post < Ohm::Model
  include Shield::Model
  include Ohm::Callbacks

  attribute :date
  attribute :expiration_date
  attribute :tags
  attribute :location
  attribute :remote
  attribute :title
  attribute :description

  index :tag
  index :location
  index :remote
  index :expired?

  def posted
    return Time.at(date.to_i).strftime("%d %B %Y")
  end

  def expires
    return (expiration_date.to_f - Time.new.to_i) / (60 * 60)
  end

  def expired?
    return (expiration_date.to_i - Time.now.to_i) <= 0
  end

  def developers
    developers = []

    applications.each do |application|
      if !developers.include?(application.developer)
        developers << application.developer
      end
    end

    favorited_by.each do |developer|
      if !developers.include?(developer)
        developers << developer
      end
    end

    return developers
  end

  def before_delete
    applications.each(&:delete)
    favorites.each(&:delete)

    favorited_by.each do |developer|
      developer.favorites.delete(self)
    end

    super
  end

  def tag
    tags.split(/\s*,\s*/).uniq
  end

  reference :company, :Company

  collection :applications, :Application
  set :favorites, :Application
  set :favorited_by, :Developer
end
