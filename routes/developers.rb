class Developers < Cuba
  define do
    on get, root do
      res.redirect "/applications"
    end

    on "dashboard" do
      apply_id = session[:apply_id]
      favorite_id = session[:favorite_id]

      if apply_id
        session.delete(:apply_id)
        res.redirect "/apply/#{apply_id}"
      end

      if favorite_id
        session.delete(:favorite_id)
        res.redirect "/favorite/#{favorite_id}"
      end

      on default do
        render("developer/applications", title: "My applications",
        search: true, query: "", applications: current_user.active_applications,
        active_applications: true)
      end
    end

    on "search" do
      run Searches
    end

    on "applications" do
      render("developer/applications", title: "Active applications",
        search: true, query: "", applications: current_user.active_applications,
        active_applications: true)
    end

    on "history" do
      render("developer/applications", title: "Discarded applications",
        subtitle: "There aren't discarded applications.",
        search: true, query: "", active_applications: false,
        applications: current_user.inactive_applications)
    end

    on "remove/:id" do |id|
      Application[id].delete
      session[:success] = "Application successfully removed!"
      res.redirect "/applications"
    end

    on "favorites" do
      render("developer/favorites", title: "Favorites",
        search: true, query: "")
    end

    on "apply/:id" do |id|
      time = Time.new.to_i
      developer = current_developer
      post = Post[id]

      params = { date: time,
        developer_id: developer.id,
        post_id: id,
        status: "active" }

      if !developer.applied?(post.id)
        application = Application.create(params)

        session[:success] = "You have successfully applied for a job!"
        res.redirect "/search?query=#{session[:query]}"
      end

      on default do
        res.redirect "/search?query=#{session[:query]}"
      end
    end

    on "message/:post_id/:developer_id" do |post_id, developer_id|
      applications = Post[post_id].applications

      application = Application[applications.find(:developer_id => developer_id).ids[0]]

      on param("message") do |message|
        msg = SendMessage.new(:message => message)

        on msg.valid? do
          application.update(:message => message)
        end

        on defaul do
          session[:error] = "Your message exceeds the character limit."
        end
      end

      on get, root do
        res.redirect "/search"
      end

      on(default) { not_found! }
    end

    on "note/:id" do |id|
      application = Application[id]

      on param("note") do |note|
        if note == "empty"
          note = ""
        end

        text = AddNote.new(:note => note)

        on text.valid? do
          application.update(:note => note)
        end

        on defaul do
          session[:error] = "Your message exceeds the character limit."
        end
      end

      on get, root do
        res.redirect "/search"
      end

      on(default) { not_found! }
    end

    on "favorite/:id" do |id|
      post = Post[id]
      favorites = current_user.favorites
      favorited_by = post.favorited_by

      on !favorites.member?(post) do
        favorites.add(post)
        favorited_by.add(current_user)

        res.redirect "/search?query=#{session[:query]}"
      end

      on favorites.member?(post) do

        on session[:origin] == "guests" do
          session.delete(:origin)

          res.redirect "/search?query=#{session[:query]}"
        end

        on default do
          favorites.delete(post)
          favorited_by.delete(current_user)

          res.redirect "/search?query=#{session[:query]}"
        end
      end

      on default do
        res.redirect "/favorites"
      end
    end

    on "profile" do
      on post, param("developer") do |params|
        developer = current_developer

        if !params["url"].empty? &&
          !params["url"].start_with?("http")
          params["url"] = "http://" + params["url"]
        end

        login = DeveloperLogin.new(params)

        on login.valid? do
          developer.update(params)

          session[:success] = "Your account was successfully updated!"
          res.redirect "/profile"
        end

        on default do
          session[:error] = "All fields are required and must be valid"
          render("developer/profile", title: "Edit profile")
        end
      end

      on get, root do
        render("developer/profile", title: "Edit profile")
      end

      on(default) { not_found! }
    end

    on "signup" do
      session[:error] = "You need to signup as a Company to be able to publish posts."
      res.redirect "/pricing"
    end

    on "logout" do
      logout(Developer)

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
      current_user.delete

      session[:success] = "You have deleted your account."
      res.redirect "/"
    end

    on(default) { not_found! }
  end
end
