require_relative "../app"

Ost[:developer_applied].each do |id|
  application = Application[id]

  text = Mailer.render("developer_applied",
  { application: application, post: application.post })

  Malone.deliver(
    from: "team@punchgirls.com",
    to: application.post.company.email,
    subject: "[Job Board] A developer applied for one of your posts!",
    text: text)
end
