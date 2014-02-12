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

  Mailer.deliver(developer.email,
    "[job board] You just received a message from " + company.name + "!", text, company.email)

  Mailer.deliver(company.email,
    "[job board] Copy of your message sent to " + developer.name, text_copy)

  message.delete
end
