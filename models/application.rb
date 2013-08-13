class Application < Ohm::Model
  include Shield::Model

  attribute :date

  def applied
    return Time.at(date.to_i).strftime("%d %B %Y")
  end

  reference :post, :Post
  reference :developer, :Developer
end
