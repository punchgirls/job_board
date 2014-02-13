require_relative "../app"

Ost[:deleted_application].each do |id|
  application = Application[id]

  text = Mailer.render("deleted_application", { application: application,
  post: application.post })

  Mailer.deliver(application.post.company.email,
    "[Job Board] Application has been removed by applicant", text)

  application.delete
end
