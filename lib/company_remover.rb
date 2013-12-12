module CompanyRemover
  def self.remove(company)
    company.posts.each do |post|
      post.developers.each do |developer|
        text = Mailer.render("../mails/delete_account", { post: post,
        developer: developer })

        Mailer.deliver(developer.email,
          "Auto-notice: '" + post.company.name + "' removed their profile", text)
      end
    end

    stripe_customer = Stripe.delete_customer(company.customer_id)

    if !stripe_customer.instance_of?(Stripe::Customer)
      text = Mailer.render("../mails/stripe_error", { company: company,
        stripe_error: stripe_customer.message })

      Mailer.deliver("team@punchgirls.com",
          "Stripe error", text)
    else
      company.delete
    end
  end
end
