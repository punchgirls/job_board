require_relative "../app"

Ost[:developer_sent_message].each do |id|
  application = Application[id]

  text = Mailer.render("developer_sent_message", {
    application: application, post: application.post })

  Mailer.deliver(application.post.company.email,
    "Message received from applicant", text)
end