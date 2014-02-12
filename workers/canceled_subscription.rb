require_relative "../app"

Ost[:canceled_subscription].each do |id|
  company = Company[id]

  text = Mailer.render("canceled_subscription", { company: company })

  Mailer.deliver(company.email,
    "[job board] Your subscription has been canceled", text)
end
