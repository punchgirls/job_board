class Contacts < Cuba
  define do
    on post, param("contact") do |params|
      mail = ContactUs.new(params)

      if mail.valid?
        text = Mailer.render("contact", params: params)

        Mailer.deliver("team@punchgirls.com",
          "Contact Form: " + params["subject"],
          text, replyto: params["email"])

        session[:success] = "Thanks for contacting us!"
        res.redirect "/"
      else
        session[:error] = "All fields are required"
        render("contact", title: "Contact", contact: params)
      end
    end

    on get, root do
      render("contact", title: "Contact", contact: {})
    end

    on(default) { not_found! }
  end
end
