class DeveloperLogin < Scrivener
  attr_accessor :name, :email, :url, :bio

  def validate
    assert_present :name
    assert_email :email

    unless url.empty?
      assert_url :url
    end

    unless bio.empty?
      assert_length :bio, 1..200
    end
  end
end
