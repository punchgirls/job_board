class Extension < Scrivener
  attr_accessor :days

  def validate
    assert_format :days, /\A(15|30)\Z/
  end
end
