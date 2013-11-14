class Companies < Cuba
  define do
    on root do
      render("company/dashboard", title: "Dashboard")
    end

    on "dashboard" do
      on root do
        render("company/dashboard", title: "Dashboard")
      end

      on param "company" do
        session[:error] = "You need to logout to sign in as a developer"
        render("company/dashboard", title: "Dashboard")
      end

      on(default) { not_found! }
    end

    on "payment" do
      company = current_company

      on root do
        begin
          customer = Stripe::Customer.retrieve(company.customer_id)
          card = customer.cards["data"][0]
        rescue Stripe::APIConnectionError => e
          session[:error] = "It looks like we are having some problems
              with your request. Please try again in a few minutes!"

          res.redirect "/dashboard"
        end

        render("company/payment", title: "Get more posts",
          customer: customer, card: card)
      end

      on post, param("company") do |params|
        payment = Payment.new(params)

        on payment.valid? do
          session.delete(:package)

          credits = params["credits"]

          # Charge the Customer instead of the card
          charge = Stripe.charge_customer(credits, company.customer_id)

          on !charge.instance_of?(Stripe::Charge) do
            if charge.instance_of?(Stripe::CardError)
              session[:error] = charge.message
            else
              session[:error] = "It looks like we are having some problems
              with your payment request. Please try again in a few minutes!"
            end

            session[:package] = credits
            res.redirect "/payment"
          end

          # Update the credits of the company
          company.update(:credits => company.credits.to_i + credits.to_i)

          session[:success] = "Your payment was successful. Happy posting!"
          res.redirect "/profile"
        end

        on default do
          res.redirect "/payment"
        end
      end

      on(default) { not_found! }
    end

    on "search" do
      run Searches
    end

    on "profile" do
      on root do
        begin
          customer = Stripe::Customer.retrieve(current_user.customer_id)
          card = customer.cards["data"][0]

          render("company/profile", title: "Profile",
          customer: customer, card: card)
        rescue => e
          session[:error] = "It looks like we are having some problems
                with your request. Please try again in a few minutes!"

          res.redirect "/dashboard"
        end
      end

      on(default) { not_found! }
    end

    on "edit" do
      on root do
        edit = EditCompanyAccount.new({})

        render("company/edit", title: "Edit profile", edit: edit)
      end

      on post, param("company") do |params|
        if !params["url"].start_with?("http")
          params["url"] = "http://" + params["url"]
        end

        company = current_company

        if params["password"].empty?
          params["password"] = company.crypted_password
          params["password_confirmation"] = company.crypted_password
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

            session[:success] = "Your account was successfully updated!"
            res.redirect "/profile"
          end
        end

        on default do
          render("company/edit", title: "Edit profile", edit: edit)
        end
      end

      on(default) { not_found! }
    end

    on "customer/update" do
      on root do
        render("customer/update", title: "Update payment details")
      end

      company = current_user

      on param("origin") do |origin|
        session[:origin] = origin
        res.redirect "/customer/update"
      end

      on post, param("stripeToken") do |token|
        update = Stripe.update_customer(company, token)

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

      on(default) { not_found! }
    end

    on "post/new" do
      on root do
        if company.credits.to_i > 0
          post = PostJobOffer.new({})

          render("company/post/new", title: "Post job offer", post: post)
        else
          res.redirect "/payment"
        end
      end

      company = current_company

      on post, param("post") do |params|
        post = PostJobOffer.new(params)

        on post.valid? do
          time = Time.new.to_i

          params[:company_id] = company.id
          params[:date] = time
          params[:expiration_date] = time + (30 * 24 * 60 * 60)

          if params["remote"].nil?
            params["remote"] = false
          end

          job = Post.create(params)
          company.update(credits: company.credits.to_i - 1)

          session[:success] = "You have successfully posted a job offer!"
          res.redirect "/dashboard"
        end

        on default do
          render("company/post/new", title: "Post job offer", post: post)
        end
      end

      on(default) { not_found! }
    end

    on "post/extend/:id" do |id|
      on root do
        render("company/post/extend", title: "Extend date", id: id)
      end

      post = Post[id]
      company = post.company

      on post, param("post") do |params|
        extend_post = Extension.new(params)

        days = params["days"]

        on extend_post.valid? do
          extension = Stripe.charge_extension(days, company.customer_id)

          on !extension.instance_of?(Stripe::Charge) do
            if extension.instance_of?(Stripe::CardError)
              session[:error] = extension.message
            else
              session[:error] = "It looks like we are having some problems
              with your payment request. Please try again in a few minutes!"
            end

            res.redirect "/post/extend/#{id}"
          end

          if post.expired?
            time = Time.new.to_i

            new_date = time + (days.to_i * 24 * 60 * 60)
            new_posted_date = time
            post.update(date: new_posted_date)
          else
            new_date = post.expiration_date.to_i + (days.to_i * 24 * 60 * 60)
          end

          post.update(expiration_date: new_date)

          session[:success] = "You have successfully extended your post
          by #{days} days!"

          res.redirect "/dashboard"
        end

        on default do
          render("company/post/extend", title: "Extend date", id: id)
        end
      end

      on(default) { not_found! }
    end

    on "post/remove/:id" do |id|
      on root do
        post = Post[id]
        developers = post.developers

        developers.each do |developer|
          Malone.deliver(to: developer.email,
            subject: "Auto-notice: '" + post.title + "' post has been removed",
            html: mote("views/company/message/remove_post.mote",
              post: post, developer: developer))
        end

        post.delete
        session[:success] = "Post successfully removed!"
        res.redirect "/dashboard"
      end

      on(default) { not_found! }
    end

    on "post/edit/:id" do |id|
      on root do
        edit = PostJobOffer.new({})

        render("company/post/edit", title: "Edit post",
          id: id, edit: edit)
      end

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

      on(default) { not_found! }
    end

    on "post/applications/:id" do |id|
      on root do
        render("company/post/applications", title: "Applicants", id: id)
      end

      on(default) { not_found! }
    end

    on "application/remove/:id" do |id|
      on root do
        application = Application[id]
        developer = application.developer
        post = application.post
        company = post.company

        Malone.deliver(to: developer.email,
              subject: "Auto-notice: Regarding '" + post.title + "' post",
              html: mote("views/company/message/remove_application.mote",
                post: post, developer: developer))

        Application[id].delete

        session[:success] = "Applicant successfully removed!"
        res.redirect "/dashboard"
      end

      on(default) { not_found! }
    end

    on "application/contact/:id" do |id|
      on root do
        render("company/post/contact", title: "Contact developer",
          id: id, message: {})
      end

      on post, param("message") do |params|
        mail = Contact.new(params)

        if mail.valid?
          company = current_company

          Malone.deliver(to: Developer[id].email,
            cc: company.email,
            subject: params["subject"],
            html: mote("views/company/message/contact.mote",
              title: "Contact", params: params))

          session[:success] = "You just sent an e-mail to the applicant!"
          res.redirect "/dashboard"
        else
          session[:error] = "All fields are required"
          render("company/post/contact", title: "Contact developer",
            id: id, message: params)
        end
      end

      on(default) { not_found! }
    end

    on "application/favorite/:id" do |id|
      application = Application[id]
      post = application.post

      on root do
        render("company/post/applications", title: "Applicants", id: post.id)
      end

      if post.favorites.member?(application)
        post.favorites.delete(application)
      else
        post.favorites.add(application)
      end

      on(default) { not_found! }
    end

    on "logout" do
      on root do
        logout(Company)
        session[:success] = "You have successfully logged out!"
        res.redirect "/"
      end

      on(default) { not_found! }
    end

    on "delete" do
      on root do
        company = current_user
        posts = company.posts
        developers = []

        posts.each do |post|
          post.developers.each do |developer|
           if !developers.include?(developer)
            developers << developer
           end
          end
        end

        delete = Stripe.delete_customer(company.customer_id)

        on !delete.instance_of?(Stripe::Customer) do
          session[:error] = "It looks like we are having some problems
            with your request. Please try again in a few minutes!"

          res.redirect "/profile"
        end

        developers.each do |developer|
          Malone.deliver(to: developer.email,
            subject: "Auto-notice: '" + company.name + "' removed their profile",
            html: mote("views/company/message/delete_account.mote",
                developer: developer))
        end

        company.delete

        session[:success] = "You have deleted your account."
        res.redirect "/"
      end

      on(default) { not_found! }
    end

    on(default) { not_found! }
  end
end
