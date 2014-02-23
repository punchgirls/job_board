class Developers < Cuba
  define do
    developer = current_user

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
        search: true, query: "", applications: developer.active_applications,
        active_applications: true)
      end
    end

    on "search" do
      run Searches
    end

    on "applications" do
      render("developer/applications", title: "Active applications",
        subtitle: "You haven't applied for any jobs yet. Start your search now!",
        search: true, query: "", active_applications: true,
        applications: developer.active_applications)
    end

    on "history" do
      render("developer/applications", title: "Discarded applications",
        subtitle: "You have no discarded applications.",
        search: true, query: "", active_applications: false,
        applications: developer.inactive_applications)
    end

    on "remove/:id" do |id|
      application = developer.active_applications[id]

      on application do
        Ost[:deleted_application].push(id)
        res.redirect "/applications"
      end

      on default do
        not_found!
      end
    end

    on "favorites" do
      render("developer/favorites", title: "Favorites",
        search: true, query: "")
    end

    on "apply/:id" do |id|
      post = Post[id]

      on post do
        unless developer.applied?(post.id)
          application = Application.create(
            date: Time.new.to_i,
            developer_id: developer.id,
            post_id: post.id,
            status: "active"
          )

          session[:success] = "You have successfully applied for a job!"

          Ost[:developer_applied].push(application.id)
        end

        res.redirect "/applications"
      end

      on default do
        not_found!
      end
    end

    on "message/:post_id", param("message") do |post_id, message|
      on developer.applied?(post_id) do
        application = developer.applications.find(post_id: post_id).first

        on application.message.nil? do
          msg = SendMessage.new(message: message)

          on msg.valid? do
            application.update(message: msg.message)

            Ost[:developer_sent_message].push(application.id)
          end

          on default do
            session[:error] = "Your message exceeds the character limit."

            res.redirect("/applications")
          end
        end

        on default do
          not_found!
        end
      end

      on default do
        not_found!
      end
    end

    on "note/:id" do |id|
      application = developer.active_applications[id]

      on application do
        on param("note") do |note|
          text = AddNote.new(note: note)

          on text.valid? do
            application.update(note: note)
          end

          on default do
            session[:error] = "Your message exceeds the character limit."
          end
        end

        on default do
          application.update(note: "")
        end
      end

      on default do
        not_found!
      end
    end

    on "favorite/:id" do |id|
      post = Post[id]
      favorites = developer.favorites
      favorited_by = post.favorited_by

      on !favorites.member?(post) do
        favorites.add(post)
        favorited_by.add(developer)

        res.redirect "/favorites"
      end

      on favorites.member?(post) do

        on session[:origin] == "guests" do
          session.delete(:origin)

          res.redirect "/favorites"
        end

        on default do
          favorites.delete(post)
          favorited_by.delete(developer)

          res.redirect "/favorites"
        end
      end

      on default do
        res.redirect "/favorites"
      end
    end

    on "profile" do
      on post, param("developer") do |params|
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
      session[:error] = "You need to signup as a Company to be able
      to publish posts."
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
      developer.update(status: "deleted")

      logout(Developer)

      session[:success] = "You have successfully deleted your account"

      Ost[:deleted_developer].push(developer.id)

      res.redirect "/"
    end

    on(default) { not_found! }
  end
end
