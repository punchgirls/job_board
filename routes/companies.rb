class Companies < Cuba
  define do
    on "dashboard" do
      render("company_dashboard", title: "Company dashboard")
    end

    on "logout" do
      logout(Company)
      session[:success] = "You have successfully logged out!"
      render("home", title: "Home")
    end

    on default do
      render("company_dashboard", title: "Company dashboard")
    end
  end
end