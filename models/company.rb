class Company < Ohm::Model
  include Shield::Model

  attribute :company_name
  attribute :company_email
  attribute :company_url
  attribute :crypted_password

  unique :company_email

  def self.fetch(identifier)
    with(:company_email, identifier)
  end

  def posts
    Post.find(:company_id => self.id)
  end

  collection :posts, :Post
end