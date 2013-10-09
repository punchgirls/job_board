class SendMessage < Scrivener
  attr_accessor :message

  def validate
    assert_length :message, 1..200
  end
end
