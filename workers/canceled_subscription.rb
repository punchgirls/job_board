require_relative "../app"

Ost[:canceled_subscription].each do |id|
  company = Company[id]

  text = Mailer.render("canceled_subscription", { company: company })

  Malone.deliver(
    from: "team@punchgirls.com",
    to: company.email,
    subject: "[Job Board] Your subscription has been canceled",
    text: text,
    bcc: "team@punchgirls.com")
end
