class PostJobOffer < Scrivener
  attr_accessor :title, :description

  def validate
    assert_present :title
    assert_present :description
  end
end