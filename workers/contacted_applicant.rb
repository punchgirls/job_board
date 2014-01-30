require_relative "../app"

Ost[:contacted_applicant].each do |id|
  message = Message[id]
  application = message.application
  developer = application.developer
  post = application.post
  company = post.company

  text = Mailer.render("application_contact",
    { post: post, body: message.body, company: company })

  text_copy = Mailer.render("application_contact_copy",
    { post: post, subject: message.subject, body: message.body, developer: developer })

  Mailer.deliver(developer.email,
    message.subject, text, company.email)

  Mailer.deliver(company.email,
    "Copy of you message sent to developer", text_copy)

  message.delete
end
