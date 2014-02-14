class Company < Ohm::Model
  include Shield::Model
  include Ohm::Callbacks

  attribute :gravatar
  attribute :name
  attribute :email
  attribute :url
  attribute :crypted_password
  attribute :customer_id
  attribute :status

  reference :plan, :Plan

  unique :email

  def self.fetch(identifier)
    with(:email, identifier)
  end

  def active?
    status == "active"
  end

  def suspended?
    status == "suspended"
  end

  def canceled?
    status == "canceled"
  end

  def deleted?
    status == "deleted"
  end

  def published_posts
    self.posts.find(published?: true)
  end

  def before_delete
    posts.each(&:delete)

    super
  end

  collection :posts, :Post
end
