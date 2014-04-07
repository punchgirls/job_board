module CompanyRemover
  def self.remove(company)
    company.posts.each do |post|
      post.developers.each do |developer|
        text = Mailer.render("../mails/deleted_company", { post: post,
        developer: developer })

        Malone.deliver(
          from: "team@punchgirls.com",
          to: developer.email,
          subject: "[job board] " + post.posted_by + " removed their profile",
          text: text,
          bcc: "team@punchgirls.com")
      end
    end

    stripe_customer = Stripe.delete_customer(company.customer_id)

    if !stripe_customer.instance_of?(Stripe::Customer)
      text = Mailer.render("../mails/stripe_error", { company: company,
        stripe_error: stripe_customer.message })

      Malone.deliver(
        from: "team@punchgirls.com",
        to: "team@punchgirls.com",
        subject: "Stripe error",
        text: text)
    else
      company.delete
    end
  end
end
