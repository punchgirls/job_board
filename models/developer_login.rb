class DeveloperLogin < Scrivener
  attr_accessor :id, :login, :name, :email, :url, :avatar

  def validate
    assert_present :name
    assert_email :email
  end
end
