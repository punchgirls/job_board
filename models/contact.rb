class Contact < Scrivener
  attr_accessor :subject, :body

  def validate
    assert_present :subject
    assert_present :body
  end
end
