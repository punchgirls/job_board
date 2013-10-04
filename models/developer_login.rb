class DeveloperLogin < Scrivener
  attr_accessor :name, :email, :url

  def validate
    assert_present :name
    assert_email :email
  end
end
