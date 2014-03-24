require_relative "../app"

Ost[:new_post].each do |id|
  post = Post[id]
  text = Mailer.render("new_post", { post: post })

  Malone.deliver(
    from: "team@punchgirls.com",
    to: "team@punchgirls.com",
    subject: "[Job Board] New post published!",
    text: text)
end
