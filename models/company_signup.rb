class CompanySignup < Scrivener
  attr_accessor :name, :email, :url,
  :password, :password_confirmation

  def validate
    if assert_email(:email)
      assert(Company.fetch(email).nil?, [:email, :not_unique])
    end

    assert_present :name
    assert_url :url

    assert_length :password, 8..32
    assert password == password_confirmation, [:password, :not_confirmed]
  end
end
