require_relative "../app"

Ost[:welcome_company].each do |id|
  company = Company[id]
  text = Mailer.render("welcome_company", { company: company })

  Malone.deliver(
    email: company.email,
    subject: "[job board] Welcome to the Punchgirls Job Board!",
    text: text,
    bcc: "team@punchgirls.com")
end
