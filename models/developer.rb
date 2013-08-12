class Developer < Ohm::Model
  include Shield::Model

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

  collection :applications, :Application
end
