class Application < Ohm::Model
  include Shield::Model

  attribute :date
  attribute :message
  attribute :note

  def applied
    return Time.at(date.to_i).strftime("%e/%b/%y")
  end

  reference :post, :Post
  reference :developer, :Developer
end
