require_relative "../app"

Ost[:contacted_applicant].each do |data|
  id = data["id"]
  subject = data["subject"]
  body = data["body"]

  application = Application[id]
  developer = application.developer
  post = application.post
  company = post.company

  text = Mailer.render("application_contact",
    { post: post, body: body, company: company })

  text_copy = Mailer.render("application_contact_copy",
    { post: post, subject: subject, body: body, developer: developer })

  Mailer.deliver(developer.email,
    subject, text, company.email)

  Mailer.deliver(company.email,
    "Copy of you message sent to developer", text_copy)
end
