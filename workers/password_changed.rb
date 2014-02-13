require_relative "../app"

Ost[:password_changed].each do |id|
  company = Company[id]
  text = Mailer.render("password_changed", { company: company })

  Malone.deliver(
    to: company.email,
    subject: "[job board] Your password has been changed",
    text: text)
end
