class PostJobOffer < Scrivener
  attr_accessor :title, :description, :tags, :location, :remote

  def validate
    assert_present :tags

    unless !location.nil?
      assert_present :remote
    end

    unless !remote.nil?
      assert_present :location
    end

    assert_present :title
    assert_present :description
    assert_length :title, 1..50
    assert_length :description, 1..600
  end
end
