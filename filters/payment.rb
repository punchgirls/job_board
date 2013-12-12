class Payment < Scrivener
  attr_accessor :credits

  def validate
    assert_format :credits, /\A(1|5|10)\Z/
  end
end
