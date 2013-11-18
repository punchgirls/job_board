class EditCompanyAccount < Scrivener
  attr_accessor :name, :email, :url,
  :password, :password_confirmation

  def validate
    unless url.start_with?("http")
      self.url = "http://" + url
    end

    assert_present :name
    assert_email :email
    assert_url :url

    assert password.length > 5, [:password, :too_small]
    assert password == password_confirmation, [:password, :not_confirmed]
  end
end
