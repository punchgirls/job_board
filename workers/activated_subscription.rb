require_relative "../app"

Ost[:activated_subscription].each do |id|
  company = Company[id]

  text = Mailer.render("activated_subscription", { company: company })

  Malone.deliver(
    from: "team@punchgirls.com",
    to: company.email,
    subject: "[Job Board] Your subscription has been updated",
    text: text,
    bcc: "team@punchgirls.com")
end
