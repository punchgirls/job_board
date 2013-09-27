class Company < Ohm::Model
  include Shield::Model
  include Ohm::Callbacks

  attribute :name
  attribute :email
  attribute :url
  attribute :crypted_password
  attribute :customer_id
  attribute :credits

  unique :email

  def self.fetch(identifier)
    with(:email, identifier)
  end

  def before_delete
    posts.each(&:delete)
    super
  end

  collection :posts, :Post
end
