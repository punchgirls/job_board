require_relative "../app"

Ost[:password_changed].each do |id|
  company = Company[id]
  text = Mailer.render("password_changed", { company: company })

  Mailer.deliver(company.email,
    "Password change notification!", text)
end
