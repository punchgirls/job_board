class Guests < Cuba
  define do
    on "signup" do
      on post, param("company") do |params|
        signup = CompanySignup.new(params)

        on signup.valid? do
          params.delete("password_confirmation")
          company = Company.create(params)
          authenticate(company)

          session[:success] = "You have successfully signed up!"
          res.redirect "/dashboard"
        end

        on signup.errors[:email] == [:not_unique] do
          session[:error] = "This e-mail is already registered"
          render("company/signup", title: "Sign up")
        end

        on default do
          session[:error] = "All fields are required and must be valid"
          render("company/signup", title: "Sign up")
        end
    end

      on default do
        render("company/signup", title: "Sign up")
      end
    end

    on "login" do
      on post, param("email"), param("password") do |user, pass|
        if login(Company, user, pass)
          session[:success] = "You have successfully logged in!"
          res.redirect "/dashboard"
        else
          session[:error] = "Invalid email and/or password combination"
          render("company/login", title: "Login")
        end
      end

      on default do
        render("company/login", title: "Login")
      end
    end

    on "jobs" do
      on default do
        render("jobs", title: "Jobs")
      end
    end

    on "github_oauth" do
      on param("code") do |code|
        access_token = GitHub.fetch_access_token(code)

        on access_token.nil? do
          session[:error] = "There were authentication problems."
          res.redirect "/"
        end

        on default do
          res.redirect GitHub.login_url(access_token)
        end
      end

      on default do
        res.redirect GitHub.oauth_authorize
      end
    end

    on "github_login/:access_token" do |access_token|
      github_user = GitHub.fetch_user(access_token)

      developer = Developer.fetch(github_user["id"])

      if developer.nil?
        developer = Developer.create(github_id: github_user["id"],
                          username: github_user["login"],
                          name: github_user["name"],
                          email: github_user["email"])
      end

      authenticate(developer)

      session[:success] = "You have successfully logged in."
      res.redirect "/dashboard"
    end

    on default do
      res.redirect "/"
    end
  end
end