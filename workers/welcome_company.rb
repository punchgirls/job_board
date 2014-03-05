require_relative "../app"

Ost[:welcome_company].each do |id|
  company = Company[id]
  text = Mailer.render("welcome_company", { company: company })

  Malone.deliver(
    from: "team@punchgirls.com",
    to: company.email,
    subject: "[Job Board] Welcome to the Punchgirls Job Board!",
    text: text,
    bcc: "team@punchgirls.com")
end
