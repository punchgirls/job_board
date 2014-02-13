require_relative "../app"

Ost[:deleted_developer].each do |id|
  developer = Developer[id]

  developer.active_applications.ids.each do |id|
    application = Application[id]

    text = Mailer.render("deleted_developer", { application: application,
    post: application.post })

    Mailer.deliver(application.post.company.email,
        "[Job Board] " + developer.name + "'s profile has been removed", text)
  end

  developer.delete
end
