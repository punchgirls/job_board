class Post < Ohm::Model
  include Shield::Model

  attribute :title
  attribute :description

  reference :company, :Company

  collection :applications, :Application
end
