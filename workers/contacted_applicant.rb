require_relative "../app"

Ost[:contacted_applicant].each do |json|
  hash = JSON.load(json)

  application_id = hash["application_id"]
  subject = hash["subject"]
  body = hash["body"]

  application = Application[application_id]
  developer = application.developer
  post = application.post
  company = post.company

  text = Mailer.render("contacted_applicant",
    post: post, subject: subject, body: body,
    company: company, developer: developer)

  text_copy = Mailer.render("contacted_applicant_copy",
    post: post, subject: subject, body: body,
    developer: developer)

  Malone.deliver(
    from: "team@punchgirls.com",
    to: developer.email,
    subject: "[Job Board] You just received a message from #{company.name}!",
    text: text,
    replyto: company.email
  )

  Malone.deliver(
    from: "team@punchgirls.com",
    to: company.email,
    subject: "[Job Board] Copy of your message sent to #{developer.name}",
    text: text_copy
  )
end
