require_relative "../app"

Ost[:deleted_application].each do |id|
  application = Application[id]

  text = Mailer.render("deleted_application", { application: application,
  post: application.post })

  Malone.deliver(
    from: "team@punchgirls.com",
    to: application.post.company.email,
    subject: "[Job Board] Application has been removed by applicant",
    text: text)

  application.delete
end
