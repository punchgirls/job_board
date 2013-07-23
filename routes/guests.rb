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

    on default do
      res.write "Hola Guest!"
    end
  end
end