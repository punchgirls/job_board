class Companies < Cuba
  define do
    company = current_user
    customer_id = company.customer_id
    plan = company.plan

    on "search" do
      run Searches
    end

    on "profile" do
      card = Stripe.retrieve_card(customer_id)

      on card.instance_of?(Stripe::CardError) do
        session[:error] = card.message

        res.redirect "/"
      end

      on default do
        render("company/profile",
          title: "Profile", card: card, plan: plan)
      end
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
            render("company/edit",
              title: "Edit profile", edit: edit)
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
          render("company/edit",
            title: "Edit profile", edit: edit)
        end
      end

      on default do
        edit = EditCompanyAccount.new({})

        render("company/edit",
          title: "Edit profile", edit: edit)
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
        render("customer/update",
          title: "Update payment details")
      end
    end

    on "customer/history" do
      history = Stripe.payment_history(customer_id)

      on !history.instance_of?(Stripe::ListObject) do
         session[:error] = "It looks like we are having some problems
            with your request. Please try again in a few minutes!"

          res.redirect "company/profile"
      end

      on default do
        render("customer/history",
          title: "Payment details",
          history: history)
      end
    end

    on "customer/invoice/:id" do |id|
      invoice = Stripe.retrieve_invoice(id)

      on !invoice.instance_of?(Stripe::Invoice) do
        session[:error] = "It looks like we are having some problems
            with your request. Please try again in a few minutes!"

        res.redirect "company/profile"
      end

      on default do
        render("customer/invoice",
          title: "Invoice details",
          invoice: invoice, plan: plan)
      end
    end

    on "customer/subscription" do
      on post, param("company") do |params|
        update = Stripe.update_subscription(customer_id, params["plan_id"])

        on !update.instance_of?(Stripe::Customer) do
          if update.instance_of?(Stripe::CardError)
            session[:error] = update.message
          else
            session[:error] = "It looks like we are having some problems
              with your request. Please try again in a few minutes!"
          end

          res.redirect "/customer/subscription"
        end

        on default do
          if company.active?
            company.update(plan_id: params["plan_id"])

            posts = company.published_posts

            if posts.size > company.plan.posts
              posts.each do |post|
                post.update(status: "unpublished")
              end
            end
          else
            company.update(plan_id: params["plan_id"], status: "active")
          end

          Ost[:activated_subscription].push(company.id)

          res.redirect "/profile"
        end
      end

      on default do
        render("customer/subscription",
          title: "Update subscription",
          plan_id: plan.name)
      end
    end

    on "logout" do
      logout(Company)
      session[:success] = "You have successfully logged out!"
      res.redirect "/"
    end

    on "delete" do
      company.update(status: "deleted")

      logout(Company)
      session[:success] = "You have successfully deleted your account"

      Ost[:deleted_company].push(company.id)

      res.redirect "/"
    end

    on company.canceled? do
      on "dashboard" do
        res.redirect("/profile")
      end

      on default do
        not_found!
      end
    end

    on !company.canceled? do
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

        on default do
          company.update(status: "suspended")

          Ost[:canceled_subscription].push(company.id)

          res.redirect "/profile"
        end
      end

      on "post/new" do
        on post, param("post") do |params|
          post = PostJobOffer.new(params)

          on post.valid? do
            params["company_id"] = company.id
            params["date"] = Time.new.to_i
            params["tags"] = params["tags"].split(",").uniq.join(",")
            params["status"] = "published"

            if params["remote"].nil?
              params["remote"] = false
            end

            job = Post.create(params)

            Ost[:new_post].push(job.id)

            session[:success] = "You have successfully posted a job offer!"
            res.redirect "/dashboard"
          end

          on default do
            render("company/post/new",
              title: "Post job offer", post: post)
          end
        end

        on get, root do
          if company.published_posts.size <  plan.posts
            post = PostJobOffer.new({})

            render("company/post/new",
              title: "Post job offer", post: post)
          else
            session[:error] = "You can only have #{plan.posts} published post."
            res.redirect "/dashboard"
          end
        end

        on default do
          not_found!
        end
      end

      on "post/status/:id" do |id|
        post = company.posts[id]

        on post do
          on post.published? do
            post.update(status: "unpublished")

            post.favorited_by.each do |developer|
              developer.favorites.delete(post)
            end

            res.redirect "/dashboard"
          end

          on !post.published? do
            on company.published_posts.size < plan.posts do
              post.update(status: "published")

              res.redirect "/dashboard"
            end

            on default do
              session[:error] = "You can only have #{plan.posts} published post(s)."

              res.redirect "/dashboard"
            end
          end
        end

        on default do
          not_found!
        end
      end

      on "post/remove/:id" do |id|
        post = company.posts[id]

        on post do
          Ost[:deleted_post].push(id)

          res.redirect "/dashboard"
        end

        on default do
          not_found!
        end
      end

      on "post/edit/:id" do |id|
        post = company.posts[id]

        on post do
          on req.post?, param("post") do |params|
            edit = PostJobOffer.new(params)

            on edit.valid? do
              if params["remote"].nil?
                params["remote"] = false
              end

              params["tags"] = params["tags"].split(",").uniq.join(",")

              post.update(params)

              session[:success] = "Post successfully edited!"
              res.redirect "/dashboard"
            end

            on default do
              render("company/post/edit",
                title: "Edit post",
                post: post, edit: edit)
            end
          end

          on default do
            render("company/post/edit",
              title: "Edit post",
              post: post, edit: PostJobOffer.new({}))
          end
        end

        on default do
          not_found!
        end
      end

      on "post/applications/discarded/:id" do |id|
        post = company.posts[id]

        on post do
          render("company/post/applications",
            title: "Discarded applications",
            post: post, active_applications: false,
            applications: post.discarded_applications,
            text: "You have no discarded applications for this post.")
        end

        on default do
          not_found!
        end
      end

      on "post/:post_id/applications" do |post_id|
        post = company.posts[post_id]

        on post do
          render("company/post/applications",
            title: "Active applications", post: post,
            applications: post.active_applications,
            active_applications: true,
            text:"There are no active applications for this post.")
        end

        on default do
          not_found!
        end
      end

      on "application/:id/discard" do |id|
        application = Application[id]

        on application && company.posts.include?(application.post) do
          application.update(status: "discarded")

          Ost[:discarded_applicant].push(id)

          session[:success] = "Applicant successfully discarded!"

          res.redirect "/post/#{application.post.id}/applications"
        end

        on default do
          not_found!
        end
      end

      on "application/:id/add" do |id|
        application = Application[id]

        on application && company.posts.include?(application.post) do
          Application[id].update(status: "active")

          session[:success] = "Applicant successfully added to list of active applications!"

          res.redirect "/post/#{application.post.id}/applications"
        end

        on default do
          not_found!
        end
      end

      on "application/:id/contact" do |id|
        application = Application[id]

        on application && company.posts.include?(application.post) do
          on post, param("message") do |params|
            mail = Contact.new(params)

            if mail.valid?
              session[:success] = "You just sent an e-mail to the applicant!"

              message = JSON.dump(application_id: id,
                subject: params["subject"], body: params["body"])

              Ost[:contacted_applicant].push(message)

              res.redirect "/post/#{application.post.id}/applications"
            else
              session[:error] = "All fields are required"
              render("company/post/contact",
                title: "Contact developer",
                application: application, message: mail)
            end
          end

          on default do
            render("company/post/contact",
              title: "Contact developer",
              application: application, message: Contact.new({}))
          end
        end

        on default do
          not_found!
        end
      end

      on "application/:id/favorite" do |id|
        application = Application[id]

        on application && company.posts.include?(application.post) do
          post = application.post

          if post.favorites.member?(application)
            post.favorites.delete(application)
          else
            post.favorites.add(application)
          end

          res.redirect "/post/#{post.id}/applications/"
        end

        on default do
          not_found!
        end
      end

      on "signup" do
        session[:error] = "If you need to change your plan go to your
        profile page > Subscription info"
        res.redirect "/pricing"
      end

      on "dashboard" do
        on param "company" do
          session[:error] = "You need to logout to sign in as a developer"
          render("company/dashboard",
            title: "Dashboard", plan: plan)
        end

        on get, root do
          render("company/dashboard",
            title: "Dashboard", plan: plan)
        end

        on(default) { not_found! }
      end

      on default do
        not_found!
      end
    end
  end
end
