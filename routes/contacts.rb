class Contacts < Cuba
  define do
    on post, param("contact") do |params|
      mail = ContactUs.new(params)

      if mail.valid?
        session[:success] = "Thanks for contacting us!"

        message = JSON.dump(email: params["email"],
          subject: params["subject"],
          body: params["body"])

        Ost[:contact_us].push(message)

        res.redirect "/"
      else
        session[:error] = "All fields are required"
        render("contact", title: "Contact",
          contact: params, background_img: true)
      end
    end

    on default do
      render("contact", title: "Contact",
        contact: {}, background_img: true)
    end
  end
end
