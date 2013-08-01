class Developers < Cuba
  define do
    on "dashboard" do
      render("developer/dashboard", title: "Dashboard")
    end

    on "apply/:id" do |id|
      params = { date: Time.new,
        developer_id: Developer[session["Developer"]].id,
        post_id: id }

      application = Application.create(params)

      session[:success] = "You have successfully applied for a job!"
      res.redirect "/dashboard"
    end

    on "logout" do
      logout(Developer)
      session[:success] = "You have successfully logged out!"
      res.redirect "/"
    end

    on default do
      render("developer/dashboard", title: "Dashboard")
    end
  end
end
