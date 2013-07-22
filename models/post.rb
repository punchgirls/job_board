class Post < Ohm::Model
  include Shield::Model

  attribute :post_title
  attribute :post_description

  reference :company, :Company
end