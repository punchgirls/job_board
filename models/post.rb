class Post < Ohm::Model
  include Shield::Model

  attribute :title
  attribute :description

  reference :company, :Company
  reference :developer, :Developer

  collection :developers, :Developer
end