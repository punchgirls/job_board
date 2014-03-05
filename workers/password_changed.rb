require_relative "../app"

Ost[:password_changed].each do |id|
  company = Company[id]
  text = Mailer.render("password_changed", { company: company })

  Malone.deliver(
    from: "team@punchgirls.com",
    to: company.email,
    subject: "[Job Board] Your password has been changed",
    text: text)
end
