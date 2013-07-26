class Developers < Cuba
  define do
    on "dashboard" do
      render("developer_dashboard", title: "Developer dashboard")
    end

    on "logout" do
      logout(Developer)
      session[:success] = "You have successfully logged out!"
      res.redirect "/"
    end

    on default do
      render("developer_dashboard", title: "Developer dashboard")
    end
  end
end