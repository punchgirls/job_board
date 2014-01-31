require_relative "../app"

Ost[:deleted_developer].each do |id|
  developer = Developer[id]

  developer.applications.each do |application|
    text = Mailer.render("developer_deleted", { application: application,
    post: application.post })

    Mailer.deliver(application.post.company.email,
        "Auto-notice: '" + developer.name + "' removed their profile", text)
  end

  developer.delete
end
