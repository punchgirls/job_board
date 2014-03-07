require_relative "../app"

Ost[:contact_us].each do |json|
  hash = JSON.load(json)

  email = hash["email"]
  subject = hash["subject"]
  body = hash["body"]

  text = Mailer.render("contact_us",
    email: email, subject: subject, body: body)

  Malone.deliver(
    from: "team@punchgirls.com",
    to: "team@punchgirls.com",
    subject: "[Job Board] Contact form message received!",
    text: text)
end
