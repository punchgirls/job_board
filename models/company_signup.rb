class CompanySignup < Scrivener
  attr_accessor :name, :email, :url,
  :password, :password_confirmation, :customer_id, :credits

  def validate
    if assert_email(:email)
      assert(Company.fetch(email).nil?, [:email, :not_unique])
    end

    unless url.start_with?("http")
      self.url = "http://" + url
    end

    assert_present :name
    assert_url :url
    assert_format :credits, /\A(1|5|10)\Z/
    assert_length :password, 8..32
    assert password == password_confirmation, [:password, :not_confirmed]
  end
end

