class Message < Ohm::Model
  include Shield::Model

  attribute :subject
  attribute :body

  reference :application, :Application
end
