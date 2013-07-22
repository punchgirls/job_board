class Companies < Cuba
  define do
    on "dashboard" do
      res.write "Welcome to your company dashboard!"
    end

    on "logout" do
      logout(Company)
      session[:success] = "You have successfully logged out!"
      res.redirect "/", 303
    end

    on default do
      res.write "/dashboard"
    end
  end
end