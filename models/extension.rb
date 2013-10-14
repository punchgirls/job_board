class Extension < Scrivener
  attr_accessor :days

  def validate
    assert_format :days, /\A(14|30)\Z/
  end
end
