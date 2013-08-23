class Developer < Ohm::Model
  include Shield::Model
  include Ohm::Callbacks

  attribute :username
  attribute :github_id
  attribute :name
  attribute :email

  unique :github_id

  def self.fetch(identifier)
    with(:github_id, identifier)
  end

  def applied?(post_id)
    return Application.find(:post_id => post_id,
      :developer_id => self.id).any?
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
