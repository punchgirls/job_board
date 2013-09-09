class Admin < Ohm::Model
  include Shield::Model

  attribute :email
  attribute :crypted_password

  unique :email

  def self.fetch(identifier)
    with(:email, identifier)
  end
end
