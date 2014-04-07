class Post < Ohm::Model
  include Ohm::Callbacks

  attribute :date
  attribute :tags
  attribute :location
  attribute :remote
  attribute :title
  attribute :description
  attribute :status
  attribute :company_name
  attribute :url

  index :tag
  index :location
  index :remote
  index :published?

  def posted_by
    company_name || company.name
  end

  def company_url
    url || company.url
  end

  def self.active
    find(published?: true)
  end

  def posted
    return Time.at(date.to_i).strftime("%e %b.")
  end

  def published?
    return status == "published"
  end

  def active_applications
    self.applications.find(active?: true)
  end

  def discarded_applications
    self.applications.find(active?: false)
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
