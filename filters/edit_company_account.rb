class EditCompanyAccount < Scrivener
  attr_accessor :name, :email, :url,
  :password, :password_confirmation, :gravatar

  def validate
    assert_present :name
    assert_length :name, 1..30
    assert_email :email
    assert_url :url

    unless password.nil?
      assert password.length > 5, [:password, :too_small]
      assert password == password_confirmation, [:password, :not_confirmed]
    end
  end
end
