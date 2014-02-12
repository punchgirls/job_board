require_relative "../app"

Ost[:password_changed].each do |id|
  company = Company[id]
  text = Mailer.render("password_changed", { company: company })

  Mailer.deliver(company.email,
    "[job board] Your password has been changed", text)
end
