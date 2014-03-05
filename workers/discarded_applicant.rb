require_relative "../app"

Ost[:discarded_applicant].each do |id|
  application = Application[id]
  developer = application.developer
  post = application.post

  text = Mailer.render("discarded_applicant",
    { post: post, developer: developer })

  Malone.deliver(
    from: "team@punchgirls.com",
    to: developer.email,
    subject: "[Job Board] Regarding " + post.title + " post",
    text: text)
end
