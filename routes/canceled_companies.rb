class CanceledCompanies < Cuba
  define do
    company = current_user
    customer_id = company.customer_id
    plan = company.plan

    on get, root do
      render("company/profile", title: "Profile", plan: plan)
    end

    on "search" do
      run Searches
    end

    on "profile" do
      card = Stripe.retrieve_card(customer_id)

      on !card.instance_of?(Stripe::Card) do
        if card.instance_of?(Stripe::CardError)
          session[:error] = card.message

          res.redirect "/profile"
        else
          session[:error] = "It looks like we are having some problems
            with your request. Please try again in a few minutes!"

          res.redirect "/profile"
        end
      end

      render("company/profile", title: "Profile", card: card,
        plan: plan)
    end

    on "edit" do
      on post, param("company") do |params|
        url = params["url"]
        params.delete("password") if params["password"].empty?

        unless url.start_with?("http")
          params["url"] = "http://" + url
        end

        edit = EditCompanyAccount.new(params)

        on edit.valid? do
          params.delete("password_confirmation")

          on company.email != edit.email &&
            Company.with(:email, edit.email) do

            session[:error] = "E-mail is already registered"
            render("company/edit", title: "Edit profile", edit: edit)
          end

          on default do
            company.update(params)

            if !params["password"].nil?
              Ost[:password_changed].push(company.id)
            end

            session[:success] = "Your account was successfully updated!"
            res.redirect "/profile"
          end
        end

        on default do
          render("company/edit", title: "Edit profile", edit: edit)
        end
      end

      on default do
        edit = EditCompanyAccount.new({})

        render("company/edit", title: "Edit profile", edit: edit)
      end
    end

    on "customer/update" do
      on param("origin") do |origin|
        session[:origin] = origin
        res.redirect "/customer/update"
      end

      on post, param("stripe_token") do |token|
        update = Stripe.update_customer(customer_id, token)

        on !update.instance_of?(Stripe::Customer) do
          if update.instance_of?(Stripe::CardError)
            session[:error] = update.message
          else
            session[:error] = "It looks like we are having some problems
              with your request. Please try again in a few minutes!"
          end

          res.redirect "/customer/update"
        end

        on !session[:origin].nil? do
          session.delete(:origin)
          res.redirect "/payment"
        end

        on default do
          session[:success] = "You have successfully updated
            your payment details"

          res.redirect "/profile"
        end
      end

      on default do
        render("customer/update", title: "Update payment details")
      end
    end

    on "customer/history" do
      on get, root do
        history = Stripe.payment_history(customer_id)

        on !history.instance_of?(Stripe::ListObject) do
           session[:error] = "It looks like we are having some problems
              with your request. Please try again in a few minutes!"

            res.redirect "company/profile"
        end

        render("customer/history", title: "Payment details",
          history: history)
      end
    end

    on "customer/invoice/:id" do |id|
      on get, root do
        invoice = Stripe.retrieve_invoice(id)

        on !invoice.instance_of?(Stripe::Invoice) do
          session[:error] = "It looks like we are having some problems
              with your request. Please try again in a few minutes!"

          res.redirect "company/profile"
        end

        render("customer/invoice", title: "Invoice details",
          invoice: invoice, plan: plan)
      end
    end

    on "customer/subscription" do
      on post, param("company") do |params|
      update = Stripe.update_subscription(customer_id, params["plan_id"])

        company.update(status: "active", plan_id: params["plan_id"])

        on !update.instance_of?(Stripe::Customer) do
          if update.instance_of?(Stripe::CardError)
            session[:error] = update.message
          else
            session[:error] = "It looks like we are having some problems
              with your request. Please try again in a few minutes!"
          end

          res.redirect "/customer/subscription"
        end

        Ost[:activated_subscription].push(company.id)

        res.redirect "/profile"
      end

      on default do
        render("customer/subscription", title: "Update subscription",
          plan_id: plan.name)
      end
    end

    on "cancel_subscription" do
      cancel = Stripe.cancel_subscription(customer_id)

      on !cancel.instance_of?(Stripe::Customer) do
        if cancel.instance_of?(Stripe::CardError)
          session[:error] = cancel.message
        else
          session[:error] = "It looks like we are having some problems
            with your request. Please try again in a few minutes!"
        end

        res.redirect "/profile"
      end

      company.update(status: "suspended")

      Ost[:canceled_subscription].push(company.id)

      res.redirect "/profile"
    end

    on "signup" do
      session[:error] = "If you need to change your plan go to your
      profile page > Subscription info"
      res.redirect "/pricing"
    end

    on "logout" do
      logout(Company)
      session[:success] = "You have successfully logged out!"
      res.redirect "/"
    end

    on "pricing" do
      render("pricing", title: "Pricing", plan_id: "small")
    end

    on "about" do
      render("about", title: "About")
    end

    on "help" do
      render("help", title: "Help")
    end

    on "contact" do
      run Contacts
    end

    on "terms" do
      render("terms", title: "Terms and Conditions")
    end

    on "privacy" do
      render("privacy", title: "Privacy Policy")
    end

    on "delete" do
      company.update(status: "deleted")

      logout(Company)
      session[:success] = "You have successfully deleted your account"

      Ost[:deleted_company].push(company.id)

      res.redirect "/"
    end

    on default do
      session[:error] = "You need to reactivate your subscription to perform this action"
      res.redirect "/profile"
    end
  end
end
