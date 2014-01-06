module Stripe
  def self.create_customer(token, plan, email, name)
    begin
      customer = Stripe::Customer.create(
        :card => token,
        :plan => plan,
        :email => email,
        :description => name
      )
    rescue => e
      return e
    end

    return customer
  end

  def self.update_customer(customer_id, token)
    begin
      customer = Stripe::Customer.retrieve(customer_id)
      customer.card = token # obtained with Stripe.js
      customer.save
    rescue => e
      return e
    end

    return customer
  end

  def self.retrieve_card(customer_id)
    begin
      customer = Stripe::Customer.retrieve(customer_id)
      card = customer.cards["data"][0]
    rescue => e
      return e
    end

    return card
  end

  def self.payment_history(customer_id)
    begin
      history = Stripe::Invoice.all(
      :customer => customer_id
     )
    rescue => e
      return e
    end

    return history
  end

  def self.retrieve_invoice(invoice_id)
    begin
      invoice = Stripe::Invoice.retrieve(invoice_id)
    rescue => e
      return e
    end

    return invoice
  end

  def self.update_subscription(customer_id, plan)
    begin
      customer = Stripe::Customer.retrieve(customer_id)

      customer.update_subscription(
        :plan => plan,
        :prorate => true
      )
    rescue => e
      return e
    end

    return customer
  end

  def self.cancel_subscription(customer_id)
    begin
      customer = Stripe::Customer.retrieve(customer_id)
      customer.cancel_subscription
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
