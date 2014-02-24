class CompanySignup < Scrivener
  attr_accessor :gravatar, :name, :email, :url,
  :password, :password_confirmation, :plan_id

  def validate
    if assert_email(:email)
      assert(Company.fetch(email).nil?, [:email, :not_unique])
    end

    assert_present :name
    assert_length :name, 1..30
    assert_url :url
    assert_format :plan_id, /\A(small|medium|large)\Z/
    assert password.length > 5, [:password, :too_small]
    assert password == password_confirmation, [:password, :not_confirmed]
  end
end
