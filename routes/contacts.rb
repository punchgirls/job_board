class Contacts < Cuba
  define do
    on post, param("contact") do |params|
      mail = ContactUs.new(params)

      if mail.valid?
        Malone.deliver(to: "team@punchgirls.com",
          subject: params["subject"],
          html: mote("views/sent_message.mote",
            title: "Message from JOB BOARD", params: params))

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
