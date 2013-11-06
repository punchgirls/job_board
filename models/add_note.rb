class AddNote < Scrivener
  attr_accessor :note

  def validate
    unless note.empty?
      assert_length :note, 1..200
    end
  end
end
