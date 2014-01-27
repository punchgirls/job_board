require_relative "../app"

Ost[:welcome_company].each do |id|
  text = Mailer.render("welcome_company", { company: Company[id] })

  Mailer.deliver(Company[id].email,
    "Welcome to Job Board!", text)
end
