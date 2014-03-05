require_relative "../app"

Ost[:developer_sent_message].each do |id|
  application = Application[id]

  text = Mailer.render("developer_sent_message", {
    application: application, post: application.post })

  Malone.deliver(
    from: "team@punchgirls.com",
    to: application.post.company.email,
    subject: "[Job Board] Message received from applicant!",
    text: text)
end
