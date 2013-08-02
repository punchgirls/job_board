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

    on "profile" do
      render("developer/profile", title: "Profile")
    end

    on "edit" do
      on post, param("developer") do |params|
        current_developer.update(params)
            session[:success] = "Your account was successfully updated!"
            res.redirect "/profile"
      end

      on default do
        render("developer/edit", title: "Edit profile")
      end
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
