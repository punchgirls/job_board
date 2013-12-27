class Companies < Cuba
  define do
    company = current_user
    customer_id = company.customer_id
    plan = company.plan

    on get, root do
      render("company/dashboard", title: "Dashboard", plan: plan)
    end

    on "dashboard" do
      on param "company" do
        session[:error] = "You need to logout to sign in as a developer"
        render("company/dashboard", title: "Dashboard", plan: plan)
      end

      on get, root do
        render("company/dashboard", title: "Dashboard", plan: plan)
      end

      on(default) { not_found! }
    end

    on "search" do
      run Searches
    end

    on "profile" do
      card = Stripe.retrieve_card(customer_id)

      on !card.instance_of?(Stripe::Card) do
        if card.instance_of?(Stripe::CardError)
          session[:error] = card.message

          res.redirect "/dashboard"
        else
          session[:error] = "It looks like we are having some problems
            with your request. Please try again in a few minutes!"

          res.redirect "/dashboard"
        end
      end

      render("company/profile", title: "Profile", card: card, plan: plan)
    end

    on "edit" do
      on post, param("company") do |params|
        company = current_company

        params.delete("password") if params["password"].empty?

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

            session[:success] = "Your account was successfully updated!"
            res.redirect "/profile"
          end
        end

        on default do
          render("company/edit", title: "Edit profile", edit: edit)
        end
      end

      on get, root do
        edit = EditCompanyAccount.new({})

        render("company/edit", title: "Edit profile", edit: edit)
      end

      on(default) { not_found! }
    end

    on "customer/update" do
      company = current_user

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

      on get, root do
        render("customer/update", title: "Update payment details")
      end

      on(default) { not_found! }
    end

    on "customer/subscription" do
      on post, param("company") do |params|
        update = Stripe.update_subscription(customer_id, params["plan_id"])

        params["status"] = "active"

        company.update(params)

        on !update.instance_of?(Stripe::Customer) do
          if update.instance_of?(Stripe::CardError)
            session[:error] = update.message
          else
            session[:error] = "It looks like we are having some problems
              with your request. Please try again in a few minutes!"
          end

          res.redirect "/customer/subscription"
        end

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

        res.redirect "/profile"
    end

    on "post/new" do
      company = current_company

      on post, param("post") do |params|
        post = PostJobOffer.new(params)

        on post.valid? do
          time = Time.new.to_i

          params["company_id"] = company.id
          params["date"] = time
          params["tags"] = params["tags"].split(", ").uniq.join
          params["status"] = "published"

          if params["remote"].nil?
            params["remote"] = false
          end

          job = Post.create(params)

          session[:success] = "You have successfully posted a job offer!"
          res.redirect "/dashboard"
        end

        on default do
          render("company/post/new", title: "Post job offer", post: post)
        end
      end

      on get, root do
        if company.published_posts.size <  plan.posts.to_i
          post = PostJobOffer.new({})

          render("company/post/new", title: "Post job offer", post: post)
        else
          session[:error] = "You can only have 1 published post."
          res.redirect "/dashboard"
        end
      end

      on(default) { not_found! }
    end

    on "post/status/:id" do |id|
      post = Post[id]

      if post.status == "published"
        post.update({ status: "unpublished"})
      else
        post.update({ status: "published"})
      end

      res.redirect "/dashboard"
    end

    on "post/remove/:id" do |id|
      post = Post[id]
      developers = post.developers

      developers.each do |developer|
        text = Mailer.render("post_remove", { post: post, developer: developer })

        Mailer.deliver(developer.email,
          "Auto-notice: '" + post.title + "' post has been removed", text)
      end

      post.delete
      session[:success] = "Post successfully removed!"
      res.redirect "/dashboard"
    end

    on "post/edit/:id" do |id|
      on post, param("post") do |params|
        post = Post[id]

        edit = PostJobOffer.new(params)

        on edit.valid? do
          if params["remote"].nil?
            params["remote"] = false
          end

          post.update(params)

          session[:success] = "Post successfully edited!"
          res.redirect "/dashboard"
        end

        on default do
          render("company/post/edit", title: "Edit post",
            id: id, edit: edit)
        end
      end

      on get, root do
        edit = PostJobOffer.new({})

        render("company/post/edit", title: "Edit post",
          id: id, edit: edit)
      end

      on(default) { not_found! }
    end

    on "post/applications/:id" do |id|
      render("company/post/applications", title: "Applicants", id: id)
    end

    on "application/remove/:id" do |id|
      application = Application[id]
      developer = application.developer
      post = application.post
      company = post.company

      text = Mailer.render("application_remove",
        { post: post, developer: developer })

      Mailer.deliver(developer.email,
        "Auto-notice: Regarding '" + post.title + "' post", text)

      Application[id].delete

      session[:success] = "Applicant successfully removed!"
      res.redirect "/dashboard"
    end

    on "application/contact/:id" do |id|
      on post, param("message") do |params|
        mail = Contact.new(params)

        if mail.valid?
          company = current_company

          text = Mailer.render("application_contact",
            { company: company, params: params })

          Mailer.deliver(Developer[id].email,
            params["subject"], text, company.email)

          session[:success] = "You just sent an e-mail to the applicant!"
          res.redirect "/dashboard"
        else
          session[:error] = "All fields are required"
          render("company/post/contact", title: "Contact developer",
            id: id, message: params)
        end
      end

      on default do
        render("company/post/contact", title: "Contact developer",
          id: id, message: {})
      end
    end

    on "application/favorite/:id" do |id|
      application = Application[id]
      post = application.post

      if post.favorites.member?(application)
        post.favorites.delete(application)
      else
        post.favorites.add(application)
      end

      on get, root do
        render("company/post/applications", title: "Applicants", id: post.id)
      end

      on(default) { not_found! }
    end

    on "logout" do
      logout(Company)
      session[:success] = "You have successfully logged out!"
      res.redirect "/"
    end

    on "pricing" do
      render("pricing", title: "Pricing", plan_id: "small")
    end

    on "how" do
      render("how", title: "How it works")
    end

    on "faq" do
      render("faq", title: "FAQ")
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
      company = current_user

      company.update(status: "suspended")

      logout(Company)
      session[:success] = "You have successfully deleted your account!"

      Ost[:companies_to_delete].push(company.id)

      res.redirect "/"
    end

    on(default) { not_found! }
  end
end
