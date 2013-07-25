class Companies < Cuba
  define do
    on "dashboard" do
      render("company_dashboard", title: "Company dashboard")
    end

    on "company_account" do
      render("company_account", title: "Company account")
    end

    on "edit_company_account/:id" do |id|
      on post, param("company") do |params|
        edit = EditCompanyAccount.new(params)

        if edit.password.empty?
          edit.password = Company[id].crypted_password
          edit.password_confirmation = Company[id].crypted_password
        end

        if edit.valid?
          params.delete("password_confirmation")

          if Company.with(:email, edit.email)
            unless Company[id].email == edit.email
              session[:error] = "E-mail is already registered"
              render("edit_company_account", title: "Edit company account", id: id)
            end
          else
            Company[id].update(params)
            session[:success] = "Your company account was successfully updated!"
            res.redirect "/company_account"
          end
        else
          if edit.errors == { :password=>[:not_confirmed] }
            session[:error] = "Passwords doesn't match"
            render("edit_company_account", title: "Edit company account", id: id)
          else
            session[:error] = "Name, E-mail and URL are required and must be valid"
            render("edit_company_account", title: "Edit company account", id: id)
          end
        end
      end

      on default do
        render("edit_company_account", title: "Edit company account", id: id)
      end
    end

    on "post_job_offer" do
      on post, param("post") do |params|
        post_job_offer = PostJobOffer.new(params)

        if post_job_offer.valid?
          params[:company_id] = Company[session["Company"]].id
          post = Post.create(params)

          session[:success] = "You have successfully posted a job offer!"
          res.redirect "/dashboard"
        else
          session[:error] = "All fields are required"
          render("post_job_offer", title: "Post job offer")
        end
      end

      on default do
        render("post_job_offer", title: "Post job offer")
      end
    end

    on "remove_post/:id" do |id|
      Post[id].delete
      session[:success] = "Post successfully removed!"
      render("company_dashboard", title: "Company dashboard")
    end

    on "edit_post/:id" do |id|
      on post, param("post") do |params|
        post_job_offer = PostJobOffer.new(params)

        if post_job_offer.valid?
          Post[id].update(params)

          session[:success] = "Post successfully edited!"
          res.redirect "/dashboard"
        else
          session[:error] = "All fields are required"
          render("post_job_offer", title: "Post job offer")
        end
      end

      on default do
        render("edit_post", title: "Edit post", id: id)
      end
    end

    on "jobs" do
      render("jobs", title: "Jobs")
    end

    on "logout" do
      logout(Company)
      session[:success] = "You have successfully logged out!"
      render("home", title: "Home")
    end

    on default do
      render("company_dashboard", title: "Company dashboard")
    end
  end
end