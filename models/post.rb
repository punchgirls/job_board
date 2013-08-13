class Post < Ohm::Model
  include Shield::Model

  attribute :date
  attribute :expiration_date
  attribute :title
  attribute :description

  def posted
    return Time.at(date.to_i).strftime("%d %B %Y")
  end

  def expires
    return (expiration_date.to_i - Time.new.to_i) / (24 * 60 * 60)
  end

  reference :company, :Company

  collection :applications, :Application
end
