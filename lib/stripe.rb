module Stripe
  def self.create_customer(token, email, name)
    begin
      customer = Stripe::Customer.create(
        :card => token,
        :email => email,
        :description => name
      )
    rescue => e
      return e
    end

    return customer
  end

  def self.charge_customer(credits, customer_id)
    sum = 0

    if credits == "1"
      sum = 10000
    elsif credits == "5"
      sum = 42500
    else
      sum = 70000
    end

    begin
      charge = Stripe::Charge.create(
        :amount => sum, # in cents
        :currency => "usd",
        :customer => customer_id
      )
    rescue => e
      return e
    end

    return charge
  end

  def self.charge_extension(days, customer_id)
    sum = 0

    if days == "14"
      sum = 4000
    else days == "30"
      sum = 8000
    end

    begin
      extension = Stripe::Charge.create(
        :amount   => sum, # in cents
        :currency => "usd",
        :customer => customer_id
      )
    rescue => e
      return e
    end

    return extension
  end

  def self.update_customer(company, token)
    begin
      customer = Stripe::Customer.retrieve(company.customer_id)
      customer.card = token # obtained with Stripe.js
      customer.save
    rescue => e
      return e
    end

    return customer
  end

  def self.delete_customer(customer_id)
    begin
      customer = Stripe::Customer.retrieve(customer_id)
      customer.delete
    rescue => e
      return e
    end

    return customer
  end
end
