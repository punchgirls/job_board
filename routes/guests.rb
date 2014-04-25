class Guests < Cuba
  define do
    on get, root do
      res.redirect "/"
    end

    on "signup" do
      on get, param("plan_id") do |plan_id|
        render("company/signup",
          title: "Sign up", plan_id: plan_id,
          company: {}, show_menu: false)
      end

      on post, param("stripe_token"), param("company") do |token, params|
        url = params["url"]

        unless url.start_with?("http")
          params["url"] = "http://" + url
        end

        signup = CompanySignup.new(params)

        on signup.valid? do
          customer = Stripe.create_customer(token,
            params["plan_id"],
            params["email"],
            params["name"]
          )

          on customer.instance_of?(Stripe::Customer) do
            params["status"] = "active"
            params["customer_id"] = customer.id
            params.delete("password_confirmation")

            company = Company.create(params)

            authenticate(company)

            session[:success] = "You have successfully signed up!"

            Ost[:welcome_company].push(company.id)

            res.redirect "/dashboard"
          end

          on default do
            signup.errors[:error_message] = [customer.message]

            render("company/signup",
              title: "Sign up", company: params,
              signup: signup, plan_id: params["plan_id"],
              show_menu: false)
          end
        end

        on default do
          render("company/signup",
            title: "Sign up", company: params,
            signup: signup, plan_id: params["plan_id"],
            show_menu: false)
        end
      end

      on default do
        render("company/signup",
          title: "Sign up", company: {},
          signup: CompanySignup.new({}), plan_id: "small",
          show_menu: false)
      end
    end

    on "login" do
      on post, param("company") do |params|

        user = params["email"]
        pass = params["password"]
        remember = params["remember"]

        if login(Company, user, pass)
          on !Company.fetch(user).deleted? do
            if remember
              remember(3600)
            end

            session[:success] = "You have successfully logged in!"
            res.redirect "/dashboard"
          end

          on default do
            session[:error] = "Your have deleted your account.
            Please create a new account."

            render("login", title: "Login", user: user)
          end
        else
          session[:error] = "Invalid email/password combination"

          render("login", title: "Login", user: user)
        end
      end

      on param("recovery") do
        session[:success] = "Check your e-mail and follow the instructions."
        res.redirect "/login"
      end

      on get, root do
        render("login", title: "Login", user: "")
      end

      on default do
        not_found!
      end
    end

    on "forgot-password" do
      on get do
        render("forgot-password",
          title: "Password recovery")
      end

      on post do
        company = Company.fetch(req[:email])

        on company do
          nobi = Nobi::TimestampSigner.new(NOBI_SECRET)
          signature = nobi.sign(String(company.id))

          Malone.deliver(
            from: "team@punchgirls.com",
            to: company.email,
            subject: "[Job Board] Password recovery",
            html: "To reset your password, please copy and paste this link into your browser's URL address bar: " +
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
      company = Otp.unsign(signature, 7200)

      on company do
        on post, param("company") do |params|
          reset = PasswordRecovery.new(params)

          on reset.valid? do
            company.update(password: reset.password)

            authenticate(company)

            session[:success] = "You have successfully changed
            your password and logged in!"

            Ost[:password_changed].push(company.id)

            res.redirect "/", 303
          end

          on default do
            render("otp", title: "Password recovery",
              company: company, signature: signature,
              reset: reset)
          end
        end

        on default do
          render("otp", title: "Password recovery",
            company: company, signature: signature)
        end
      end

      on get, root do
        session[:error] = "Invalid or expired URL. Please try again!"
        res.redirect("/forgot-password")
      end

      on(default) { not_found! }
    end

    on "password/:signature" do |signature|
      company = Otp.unsign(signature, 604800)

      on company do
        on post, param("company") do |params|
          reset = PasswordRecovery.new(params)

          on reset.valid? do
            company.update(password: reset.password)

            authenticate(company)

            session[:success] = "You have successfully changed
            your password and logged in!"

            Ost[:password_changed].push(company.id)

            res.redirect "/", 303
          end

          on default do
            render("first_time_login", title: "First time login",
              company: company, signature: signature, reset: reset)
          end
        end

        on default do
          render("first_time_login", title: "First time login",
            company: company, signature: signature)
        end
      end

      on get, root do
        session[:error] = "This URL has expired. Send a mail to team@punchgirls.com and we'll send you a new one right away!"
        res.redirect "/password"
      end

      on default do
        not_found!
      end
    end

    on "search" do
      run Searches
    end

    on "apply", param("post_id") do |id|
      session[:apply_id] = id

      res.redirect "/github_oauth"
    end

    on "favorite", param("post_id") do |id|
      session[:favorite_id] = id
      session[:origin] = "guests"

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

      on get, root do
        res.redirect GitHub.oauth_authorize
      end

      on(default) { not_found! }
    end

    on "github_login/:access_token" do |access_token|
      apply_id = session[:apply_id]
      favorite = session[:favorite_id]
      origin = session[:origin]

      github_user = GitHub.fetch_user(access_token)

      developer = Developer.fetch(github_user["id"])

      on developer do
        if !Developer.fetch(github_user["id"]).deleted?
          authenticate(developer)

          session[:success] = "You have successfully logged in."
          session[:apply_id] = apply_id
          session[:favorite_id] = favorite
          session[:origin] = origin

          res.redirect "/dashboard"
        else
          session[:error] = "Your have just deleted your account.
          Please try to login again in a few minutes."

          render("login", title: "Login",
            user: current_user)
        end
      end

      on developer.nil? do
        session[:github_id] = github_user["id"]
        session[:username] = github_user["login"]
        session[:gravatar] = github_user["gravatar_id"]

        render("confirm",
          title: "Confirm your user details",
          github_user: github_user)
      end
    end

    on "confirm" do
      apply_id = session[:apply_id]
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
            gravatar: session[:gravatar])

          authenticate(developer)

          session[:apply_id] = apply_id
          session[:favorite_id] = favorite
          session[:origin] = origin

          session[:success] = "You have successfully logged in!"

          Ost[:welcome_developer].push(developer.id)

          res.redirect "/dashboard"
        end

        on default do
          session[:error] = "Name and E-mail are required and must be valid"
          render("confirm",
            title: "Confirm your user details",
            github_user: params)
        end
      end

      on get, root do
        render("confirm",
          title: "Confirm your user details")
      end

      on default do
        not_found!
      end
    end

    on default do
      not_found!
    end
  end
end
