class Application < Ohm::Model
  include Shield::Model

  attribute :date
  attribute :message
  attribute :note
  attribute :status

  index :status
  index :active?

  def active?
    return status == "active"
  end

  def applied
    return Time.at(date.to_i).strftime("%e/%b/%y")
  end

  reference :post, :Post
  reference :developer, :Developer
end
