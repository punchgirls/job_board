class Message < Ohm::Model
  attribute :subject
  attribute :body

  reference :application, :Application
end
