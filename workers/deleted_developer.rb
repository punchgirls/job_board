require_relative "../app"

Ost[:deleted_developer].each do |id|
  developer = Developer[id]

  developer.active_applications.each do |application|
    text = Mailer.render("deleted_developer", { application: application,
    post: application.post })

    Malone.deliver(
      from: "team@punchgirls.com",
      to: application.post.company.email,
      subject: "[Job Board] " + developer.name + "'s profile has been removed",
      text: text,
      bcc: "team@punchgirls.com")
  end

  developer.delete
end
