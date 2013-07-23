class Company < Ohm::Model
  include Shield::Model

  attribute :name
  attribute :email
  attribute :url
  attribute :crypted_password

  unique :email

  def self.fetch(identifier)
    with(:email, identifier)
  end

  def posts
    Post.find(:id => self.id)
  end

  collection :posts, :Post
end