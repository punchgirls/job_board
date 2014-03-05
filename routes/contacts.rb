class Contacts < Cuba
  define do
    on post, param("contact") do |params|
      mail = ContactUs.new(params)

      if mail.valid?
        text = Mailer.render("contact", params: params)

        Malone.deliver(
          from: "team@punchgirls.com",
          to: "team@punchgirls.com",
          subject: "Contact Form: " + params["subject"],
          text: text,
          replyto: params["email"])

        session[:success] = "Thanks for contacting us!"
        res.redirect "/"
      else
        session[:error] = "All fields are required"
        render("contact", title: "Contact", contact: params, background_img: true)
      end
    end

    on get, root do
      render("contact", title: "Contact", contact: {}, background_img: true)
    end

    on default do
      not_found!
    end
  end
end
