class CompanySignup < Scrivener
  attr_accessor :gravatar, :name, :email, :url,
  :password, :password_confirmation, :customer, :plan_id

  def validate
    unless customer.instance_of?(Stripe::Customer)
      self.errors[:error_message] = [customer.message]
    end

    if assert_email(:email)
      assert(Company.fetch(email).nil?, [:email, :not_unique])
    end

    unless url.start_with?("http")
      self.url = "http://" + url
    end

    assert_present :name
    assert_url :url
    assert_format :plan_id, /\A(small|medium|large)\Z/
    assert password.length > 5, [:password, :too_small]
    assert password == password_confirmation, [:password, :not_confirmed]
  end
end
