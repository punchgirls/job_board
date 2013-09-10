class PostJobOffer < Scrivener
  attr_accessor :title, :description, :tags, :location, :remote

  def validate
    assert_present :tags
    assert_present :location
    assert_present :title
    assert_present :description
    assert_length :title, 1..80
    assert_length :description, 1..600
  end
end
