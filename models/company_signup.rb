class CompanySignup < Scrivener
  attr_accessor :name, :email, :url,
  :password, :password_confirmation, :customer_id, :credits, :customer

  def validate
    unless customer.instance_of?(Stripe::Customer)
      self.errors[:error_message] = [customer.message]
    else
      charge = Stripe.charge_customer(credits, customer.id)

      unless charge.instance_of?(Stripe::Charge)
        self.errors[:error_message] = [charge.message]

        delete = Stripe.delete_customer(customer.id)

        unless delete.instance_of?(Stripe::Customer)
          session[:error] = "It looks like we are having some problems
          with your request. Please try again in a few minutes!"
        end
      end
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

