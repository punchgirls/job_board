class PostJobOffer < Scrivener
  attr_accessor :title, :description

  def validate
    assert_present  :title
    assert_present  :description
    assert_length  :title, 1..80
    assert_length  :description, 1..600
  end
end