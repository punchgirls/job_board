class Developers < Cuba
  define do
    on "dashboard" do
      render("developer/dashboard", title: "Dashboard")
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