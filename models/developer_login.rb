class DeveloperLogin < Scrivener
  attr_accessor :name, :email, :url, :bio

  def validate
    assert_present :name
    assert_email :email

    unless bio.empty?
      assert_length :bio, 1..200
    end
  end
end
