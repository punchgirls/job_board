class CompanySignup < Scrivener
  attr_accessor :company_name, :company_email, :company_url, :password, :password_confirmation

  def validate
    if assert_email(:company_email)
      assert(Company.fetch(company_email).nil?, [:company_email, :not_unique])
    end

    assert_present :company_name
    assert_url :company_url

    assert_present :password
    assert password == password_confirmation, [:password, :not_confirmed]
  end
end