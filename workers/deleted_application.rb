require_relative "../app"

Ost[:deleted_application].each do |id|
  application = Application[id]

  text = Mailer.render("deleted_application", { application: application,
  post: application.post })

  Mailer.deliver(application.post.company.email,
    "Application remove notification", text)

  application.delete
end
