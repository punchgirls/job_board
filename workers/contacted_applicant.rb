require_relative "../app"

Ost[:contacted_applicant].each do |id|
  message = Message[id]
  application = message.application
  developer = application.developer
  post = application.post
  company = post.company

  text = Mailer.render("contacted_applicant",
    { post: post, subject: message.subject, body: message.body,
      company: company, developer: developer })

  text_copy = Mailer.render("contacted_applicant_copy",
    { post: post, subject: message.subject, body: message.body,
      developer: developer })

  Malone.deliver(
    to: developer.email,
    subject: "[Job Board] You just received a message from " + company.name + "!",
    text: text,
    replyto: company.email)

  Malone.deliver(
    to: company.email,
    subject: "[Job Board] Copy of your message sent to " + developer.name,
    text: text_copy)

  message.delete
end
