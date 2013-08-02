class DeveloperLogin < Scrivener
  attr_accessor :id, :login, :name, :email

  def validate
    assert_present :name
    assert_email :email
  end
end
