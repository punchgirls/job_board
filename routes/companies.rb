class Companies < Cuba
  define do
    on "dashboard" do
      render("company/dashboard", title: "Dashboard")
    end

    on "profile" do
      render("company/profile", title: "Profile")
    end

    on "edit" do
      on post, param("company") do |params|
        edit = EditCompanyAccount.new(params)

        if edit.password.empty?
          edit.password = current_company.crypted_password
          edit.password_confirmation = current_company.crypted_password
        end

        on edit.valid? do
          params.delete("password_confirmation")

          on current_company.email != edit.email &&
            Company.with(:email, edit.email) do
            session[:error] = "E-mail is already registered"
            render("company/edit", title: "Edit profile")
          end

          on default do
            current_company.update(params)
            session[:success] = "Your account was successfully updated!"
            res.redirect "/profile"
          end
        end

        on edit.errors[:password] == [:not_confirmed] do
          session[:error] = "Passwords don't match"
          render("company/edit", title: "Edit profile")
        end

        on default do
          session[:error] = "Name, E-mail and URL are required and must be valid"
          render("company/edit", title: "Edit profile")
        end
      end

      on default do
        render("company/edit", title: "Edit profile")
      end
    end

    on "jobs/new" do
      on post, param("post") do |params|
        job = PostJobOffer.new(params)

        on job.valid? do
          time = Time.new.to_i

          params[:company_id] = current_company.id
          params[:date] = time
          params[:expiration_date] = time + (31*24*60*60)

          post = Post.create(params)

          session[:success] = "You have successfully posted a job offer!"
          res.redirect "/dashboard"
        end

        on job.errors[:title] == [:not_in_range] do
          session[:error] = "Title should not exceed 80 characters"
          render("company/jobs/new", title: "Post job offer", post: params)
        end

        on job.errors[:description] == [:not_in_range] do
          session[:error] = "Description should not exceed 300 characters"
          render("company/jobs/new", title: "Post job offer", post: params)
        end

        on default do
          session[:error] = "All fields are required"
          render("company/jobs/new", title: "Post job offer", post: params)
        end
      end

      on default do
        render("company/jobs/new", title: "Post job offer", post: {})
      end
    end

    on "jobs/remove/:id" do |id|
      Post[id].delete
      session[:success] = "Post successfully removed!"
      res.redirect "/dashboard"
    end

    on "jobs/edit/:id" do |id|
      on post, param("post") do |params|
        job = PostJobOffer.new(params)

        if job.valid?
          Post[id].update(params)

          session[:success] = "Post successfully edited!"
          res.redirect "/dashboard"
        else
          session[:error] = "All fields are required"
          render("company/jobs/edit", title: "Edit post")
        end
      end

      on default do
        render("company/jobs/edit", title: "Edit post", id: id)
      end
    end

    on "jobs/applicants/:id" do |id|
      render("company/jobs/applicants", title: "Applicants", id: id)
    end

    on "jobs/contact/:id" do |id|
      on post, param("message") do |params|
        mail = Contact.new(params)

        if mail.valid?
          company = current_company

          Malone.deliver(to: Developer[id].email,
            cc: company.email,
            subject: params["subject"],
            html: "<p>" + params["body"] +
            "</p>" + "<a href='mailto:" +
            company.email + "?subject=RE: " +
            params["subject"] +
            "&body=" + "From " + company.name + ":\n" +
            params["body"] +
            "'>Reply to company</a>")

          session[:success] = "You just sent an e-mail to the applicant!"
          res.redirect "/dashboard"
        else
          session[:error] = "All fields are required"
          render("company/jobs/contact", title: "Contact developer",
            id: id, message: params)
        end

      end

      on default do
        render("company/jobs/contact", title: "Contact developer",
          id: id, message: {})
      end
    end

    on "jobs" do
      render("jobs", title: "Jobs")
    end

    on "logout" do
      logout(Company)
      session[:success] = "You have successfully logged out!"
      res.redirect "/"
    end

    on default do
      render("company/dashboard", title: "Dashboard")
    end
  end
end
