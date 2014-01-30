require_relative "../app"

Ost[:developer_applied].each do |id|
  application = Application[id]

  text = Mailer.render("developer_applied", { application: application, post: application.post })

  Mailer.deliver(application.post.company.email,
    "You have a new applicant", text)
end