class Developer < Ohm::Model
  include Ohm::Callbacks

  attribute :username
  attribute :github_id
  attribute :name
  attribute :email
  attribute :url
  attribute :gravatar
  attribute :bio
  attribute :status

  index :email

  unique :github_id

  def self.fetch(identifier)
    with(:github_id, identifier)
  end

  def deleted?
    status == "deleted"
  end

  def applied?(post_id)
    Application.find(post_id: post_id,
      developer_id: id).except(status: "canceled").any?
  end

  def active_applications
    self.applications.find(active?: true)
  end

  def inactive_applications
    self.applications.find(active?: false).except(status: "deleted")
  end

  def before_delete
    applications.each(&:delete)

    favorites.each do |post|
      post.favorited_by.delete(self)
      favorites.delete(post)
    end

    super
  end

  collection :applications, :Application
  set :favorites, :Post
end
