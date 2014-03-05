require_relative "../app"

Ost[:welcome_developer].each do |id|
  developer = Developer[id]
  text = Mailer.render("welcome_developer", { developer: developer })

  Malone.deliver(
    from: "team@punchgirls.com",
    to: developer.email,
    subject: "[Job Board] Welcome to the Punchgirls Job Board!",
    text: text,
    bcc: "team@punchgirls.com")
end
