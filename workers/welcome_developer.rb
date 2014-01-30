require_relative "../app"

Ost[:welcome_developer].each do |id|
  developer = Developer[id]
  text = Mailer.render("welcome_developer", { developer: developer })

  Mailer.deliver(developer.email,
    "Welcome to Job Board!", text)
end
