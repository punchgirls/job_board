class AddNote < Scrivener
  attr_accessor :note

  def validate
    assert_length :note, 1..200
  end
end
