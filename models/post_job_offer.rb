class PostJobOffer < Scrivener
  attr_accessor :title, :description, :tags

  def validate
    assert_present :tags
    assert_length :title, 1..80
    assert_length :description, 1..600
  end
end
