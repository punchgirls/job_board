require_relative "../app"

Ost[:discarded_applicant].each do |id|
  application = Application[id]
  developer = application.developer
  post = application.post

  text = Mailer.render("discarded_applicant",
    { post: post, developer: developer })

  Malone.deliver(
    email: developer.email,
    subject: "[job board] Regarding " + post.title + " post",
    text: text)
end
