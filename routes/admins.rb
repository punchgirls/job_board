class Admins < Cuba
  define do
    on "companies" do
      render("admin/companies", title: "Companies")
    end

    on "edit/:id" do |id|
      on post, param("company") do |params|
        if !params["url"].start_with?("http")
          params["url"] = "http://" + params["url"]
        end

        company = Company[id]

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
            render("company/edit", title: "Edit profile", edit: edit, id: id)
          end

          on default do
            company.update(params)

            session[:success] = "Company was successfully updated!"
            res.redirect "/companies"
          end
        end

        on default do
          render("company/edit", title: "Edit profile", edit: edit, id: id)
        end
      end

      on default do
        edit = EditCompanyAccount.new({})

        render("company/edit", title: "Edit profile", edit: edit, id: id)
      end
    end

    on "company/:id/delete" do |id|
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
      session[:success] = "You have deleted the company account."
      res.redirect "/companies"
    end

    on "profile/:id" do |id|
      on post, param("developer") do |params|
        developer = Developer[id]

        login = DeveloperLogin.new(params)

        on login.valid? do
          developer.update(params)

          session[:success] = "Your account was successfully updated!"
          res.redirect "/developers"
        end

        on default do
          session[:error] = "All fields are required and must be valid"
          render("developer/profile", title: "Edit profile", id: id)
        end
      end

      on default do
        render("developer/profile", title: "Edit profile", id: id)
      end
    end

    on "developer/:id/delete" do |id|
      Developer[id].delete

      session[:success] = "You have deleted your account."
      res.redirect "/developers"
    end

    on "posts/:id" do |id|
      company = Company[id]
      posts = company.posts
      render("admin/companies/posts", title: "Posts",
        company: company, posts: posts)
    end

    on "post/edit/:id" do |id|
      on post, param("post") do |params|
        post = Post[id]

        params["tags"] = params["tags"].split(",")

        if params["tags"].nil?
          params["tags"] = Post[id].tags
        else
          params["tags"] = params["tags"].uniq.join(", ")
        end

        edit = PostJobOffer.new(params)

        on edit.valid? do
          post.update(params)

          session[:success] = "Post successfully edited!"
          res.redirect "/companies"
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
      res.redirect "/companies"
    end

    on "applications/:id" do |id|
      post = Post[id]
      company = post.company
      applications = post.applications

      render("admin/companies/applications", title: "Applications",
        company: company, applications: applications)
    end

    on "remove/:id" do |id|
      Application[id].delete
      session[:success] = "Application successfully removed!"
      res.redirect "/developers"
    end

    on "post/:id/favorited" do |id|
      post = Post[id]
      favorited_by = post.favorited_by
      company = post.company

      render("admin/companies/favorited", title: "Favorited",
        post: post, favorited_by: favorited_by, company: company)
    end

    on "developers" do
      render("admin/developers", title: "Developers")
    end

    on "developer/:id/applications" do |id|
      developer = Developer[id]
      applications = developer.applications

      render("admin/developers/applications", title: "Applications",
      developer: developer, applications: applications)
    end

    on "developer/:id/favorites" do |id|
      developer = Developer[id]
      favorites = developer.favorites

      render("admin/developers/favorites", title: "Applications",
      developer: developer, favorites: favorites)
    end

    on "search" do
      run Searches
    end

    on "logout" do
      logout(Admin)
      session[:success] = "You have successfully logged out!"
      res.redirect "/"
    end

    on default do
      render("admin/dashboard", title: "Dashboard")
    end
  end
end
