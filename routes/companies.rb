class Companies < Cuba
  define do
    on "dashboard" do
      on param "company" do
        session[:error] = "You need to logout to sign in as a developer"
        render("company/dashboard", title: "Dashboard")
      end

      on default do
        render("company/dashboard", title: "Dashboard")
      end
    end

    on "search" do
      run Searches
    end

    on "profile" do
      render("company/profile", title: "Profile")
    end

    on "edit" do
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

      on default do
        edit = EditCompanyAccount.new({})

        render("company/edit", title: "Edit profile", edit: edit)
      end
    end

    on "post/new" do
      on post, param("post") do |params|
        post = PostJobOffer.new(params)

        on post.valid? do
          time = Time.new.to_i

          params[:company_id] = current_company.id
          params[:date] = time
          params[:expiration_date] = time + (30 * 24 * 60 * 60)

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

      on default do
        post = PostJobOffer.new({})

        render("company/post/new", title: "Post job offer", post: post)
      end
    end

    on "post/extend/:id" do |id|
      on post, param("days") do |days|
        post = Post[id]

        new_date = post.expiration_date.to_i + (days.to_i * 24 * 60 * 60)

        post.update(expiration_date: new_date)

        session[:success] = "You have successfully extended your post
        by #{days} days!"
        res.redirect "/dashboard"
      end

      on default do
        render("/company/post/extend", title: "Extend date", id: id)
      end
    end

    on "post/remove/:id" do |id|
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

    on "post/edit/:id" do |id|
      on post, param("post") do |params|
        post = Post[id]

        edit = PostJobOffer.new(params)
        res.write edit.attributes

        on edit.valid? do
          post.update(params)

          session[:success] = "Post successfully edited!"
          res.redirect "/dashboard"
        end

        on default do
          render("company/post/edit", title: "Edit post",
            id: id, edit: edit)
        end
      end

      on default do
        edit = PostJobOffer.new({})

        render("company/post/edit", title: "Edit post",
          id: id, edit: edit)
      end
    end

    on "post/applications/:id" do |id|
      render("company/post/applications", title: "Applicants", id: id)
    end

    on "application/remove/:id" do |id|
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

    on "application/contact/:id" do |id|
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

      on default do
        render("company/post/applications", title: "Applicants", id: post.id)
      end
    end

    on "logout" do
      logout(Company)
      session[:success] = "You have successfully logged out!"
      res.redirect "/"
    end

    on "delete/:id" do |id|
      company = Company[id]
      posts = company.posts
      developers = []

      posts.each do |post|
        post.developers.each do |developer|
         if !developers.include?(developer)
          developers << developer
         end
        end
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

    on default do
      render("company/dashboard", title: "Dashboard")
    end
  end
end
