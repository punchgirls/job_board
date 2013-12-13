class ContactUs < Scrivener
  attr_accessor :email, :subject, :body

  def validate
    assert_email :email
    assert_present :subject
    assert_present :body
  end
end
