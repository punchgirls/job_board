class Guests < Cuba
  define do
    on "package" do
      on post, param("company") do |params|
        session[:package] = params["credits"]
        res.redirect "/signup"
      end

      on default do
        session[:error] = "You need to choose a package first"
        res.redirect "/login"
      end
    end

    on "signup" do
      on post, param("stripeToken"), param("company") do |token, params|

        signup = CompanySignup.new(params)

        on signup.valid? do
          session.delete(:package)

          params.delete("password_confirmation")
          credits = params["credits"]
          params["credits"] = "0"

          company = Company.new(params)

          # Create a Customer
          customer = Stripe.create_customer(company, token)

          on !customer.instance_of?(Stripe::Customer) do
            if customer.instance_of?(Stripe::CardError)
              session[:error] = customer.message
            else
              session[:error] = "It looks like we are having some problems
              with your request. Please try again in a few minutes!"
            end

            session[:package] = credits
            render("company/signup", title: "Sign up",
              company: params, signup: signup)
          end

          company.update(:customer_id => customer.id)
          company.save

          authenticate(company)

          # Charge the customer
          charge = Stripe.charge_customer(credits, customer.id)

          on !charge.instance_of?(Stripe::Charge) do
            if charge.instance_of?(Stripe::CardError)
              session[:error] = "You have successfully created your account
              but unfortunately your credit card was declined, please try again with another credit card."
            else
              session[:error] = "You have successfully created your account
              but it looks like we are having some problems
              with your payment request. Please try again in a few minutes!"
            end

            session[:package] = credits
            res.redirect "/payment"
          end

          company.update(:credits => credits)

          session[:success] = "You have successfully signed up!"
          res.redirect "/dashboard"
        end

        on default do
          render("company/signup", title: "Sign up",
            company: params, signup: signup)
        end
      end

      on default do
        signup = CompanySignup.new({})

        render("company/signup", title: "Sign up",
          company: {}, signup: signup)
      end
    end

    on "login" do
      on post, param("company") do |params|
        user = params["email"]
        pass = params["password"]
        remember = params["remember"]

        if login(Company, user, pass)
          if remember
            remember(3600)
          end

          session[:success] = "You have successfully logged in!"
          res.redirect "/dashboard"
        else
          session[:error] = "Invalid email/password combination"
          render("company/login", title: "Login", user: user)
        end
      end

      on post, param("email") do |user|
        session[:error] = "No password provided"
        render("company/login", title: "Login", user: user)
      end

      on param("recovery") do
        session[:success] = "Check your e-mail and follow the instructions."
        res.redirect "/login"
      end

      on default do
        render("company/login", title: "Login", user: "")
      end
    end

    on "forgot-password" do
      on get do
        render("forgot-password", title: "Password recovery")
      end

      on post do
        company = Company.fetch(req[:email])

        on company do
          nobi = Nobi::TimestampSigner.new('my secret here')
          signature = nobi.sign(String(company.id))

          Malone.deliver(to: company.email,
            subject: "Password recovery",
            html: "Please follow this link to reset your password: " +
            RESET_URL + "/otp/%s" % signature)

          res.redirect "/login/?recovery=true", 303
        end

        on default do
          session[:error] = "Can't find a user with that e-mail."
          res.redirect("/forgot-password", 303)
        end
      end
    end

    on "otp/:signature" do |signature|
      nobi = Nobi::TimestampSigner.new('my secret here')

      company =
        begin
          company_id = nobi.unsign(signature, max_age: 7200)

          Company[company_id]
        rescue Nobi::BadData
        end

      on company do
        on post, param("company") do |params|
          reset = PasswordRecovery.new(params)

          on reset.valid? do
            company.update(password: reset.password)

            authenticate(company)

            session[:success] = "You have successfully changed
            your password and logged in!"
            res.redirect "/", 303
          end

          on default do
            render("otp", title: "Password recovery",
              company: company, signature: signature, reset: reset)
          end
        end

        on default do
          reset = PasswordRecovery.new({})

          render("otp", title: "Password recovery",
            company: company, signature: signature, reset: reset)
        end
      end

      on default do
        session[:error] = "Invalid URL. Please try again!"
        res.redirect("/forgot-password")
      end
    end

    on "search" do
      run Searches
    end

    on "apply/:id" do |id|
      session[:apply_id] = id

      res.redirect "/github_oauth"
    end

    on "favorite/:id" do |id|
      session[:favorite_id] = id
      session[:origin] = { "guests" => "true" }

      res.redirect "/github_oauth"
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
      apply_id = session[:apply_id]
      query = session[:query]
      favorite = session[:favorite_id]
      origin = session[:origin]

      github_user = GitHub.fetch_user(access_token)

      developer = Developer.fetch(github_user["id"])

      on developer.nil? do
        session[:github_id] = github_user["id"]
        session[:username] = github_user["login"]
        session[:avatar] = github_user["gravatar_id"]

        render("confirm", title: "Confirm your user details",
          github_user: github_user)
      end

      authenticate(developer)

      session[:success] = "You have successfully logged in."
      session[:apply_id] = apply_id
      session[:favorite_id] = favorite
      session[:query] = query
      session[:origin] = origin

      res.redirect "/dashboard"
    end

    on "confirm" do
      apply_id = session[:apply_id]
      query = session[:query]
      favorite = session[:favorite_id]
      origin = session[:origin]

      on post, param("developer") do |params|
        if !params["url"].empty? &&
          !params["url"].start_with?("http")
          params["url"] = "http://" + params["url"]
        end

        login = DeveloperLogin.new(params)

        on login.valid? do
          developer = Developer.create(
            github_id: session[:github_id],
            username: session[:username],
            name: params["name"],
            email: params["email"],
            url: params["url"],
            bio: params["bio"],
            avatar: session[:avatar])

          authenticate(developer)

          session[:apply_id] = apply_id
          session[:favorite_id] = favorite
          session[:query] = query
          session[:origin] = origin

          session[:success] = "You have successfully logged in!"
          res.redirect "/dashboard"
        end

        on default do
          session[:error] = "All fields are required and must be valid"
          render("confirm", title: "Confirm your user details",
            github_user: params)
        end
      end

      on default do
        render("confirm", title: "Confirm your user details")
      end
    end

    on "admin" do
      on post, param("email"), param("password") do |admin, pass|
        if login(Admin, admin, pass)
          session[:success] = "You have successfully logged in!"
          res.redirect "/dashboard"
        else
          session[:error] = "Invalid email/password combination"
          render("admin/login", title: "Admin Login", admin: admin)
        end
      end

      on post, param("email") do |admin|
        session[:error] = "No password provided"
        render("admin/login", title: "Admin Login", admin: admin)
      end

      on default do
        render("admin/login", title: "Admin Login", admin: "")
      end
    end

    on default do
      res.redirect "/"
    end
  end
end
