class Guests < Cuba
  define do
    on "company_signup" do
      on post, param("company") do |params|
        company_signup = CompanySignup.new(params)

        if company_signup.valid?
          params.delete("password_confirmation")
          company = Company.create(params)
          authenticate(company)

          session[:success] = "You have successfully signed up!"
          res.redirect "/dashboard"
        elsif Company.with(:email, company_signup.email)
          session[:error] = "This e-mail is already registered"
          render("company_signup", title: "Company signup")
        else
          session[:error] = "All fields are required and must be valid"
          render("company_signup", title: "Company signup")
        end
      end

      on default do
        render("company_signup", title: "Company signup")
      end
    end

    on "company_login" do
      on post, param("email"), param("password") do |user, pass|
        if login(Company, user, pass)
          session[:success] = "You have successfully logged in!"
          res.redirect "/dashboard"
        else
          session[:error] = "Invalid email and/or password combination"
          res.redirect("/company_login")
        end
      end
      on default do
        render("company_login", title: "Company login")
      end
    end

    on default do
      res.redirect "/"
    end
  end
end