require_relative "../app"

Ost[:activated_subscription].each do |id|
  company = Company[id]

  text = Mailer.render("activated_subscription", { company: company })

  Mailer.deliver(company.email,
    "Your subscription has been activated", text)
end
