require_relative "../app"

Ost[:developer_sent_message].each do |id|
  application = Application[id]

  text = Mailer.render("developer_sent_message", {
    application: application, post: application.post })

  Malone.deliver(
    email: application.post.company.email,
    subject: "[job board] Message received from applicant!",
    text: text)
end
