class Application < Ohm::Model
  include Shield::Model

  attribute :date

  reference :post, :Post
  reference :developer, :Developer

  collection :developers, :Developer
end