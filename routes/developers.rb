class Developers < Cuba
  define do
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
        render("developer/dashboard", title: "Dashboard")
      end
    end

    on "search" do
      run Searches
    end

    on "applications" do
      render("developer/applications", title: "My applications")
    end

    on "remove/:id" do |id|
      Application[id].delete
      session[:success] = "Application successfully removed!"
      res.redirect "/applications"
    end

    on "favorites" do
      render("developer/favorites", title: "Favorites")
    end

    on "apply/:id" do |id|
      time = Time.new.to_i
      developer = current_developer
      post = Post[id]

      params = { date: time,
        developer_id: developer.id,
        post_id: id }

      if !developer.applied?(post.id)
        application = Application.create(params)

        session[:success] = "You have successfully applied for a job!"
      end

      on default do
        res.redirect "/search"
      end
    end

    on "favorite/:id" do |id|
      post = Post[id]
      favorites = current_user.favorites
      favorited_by = post.favorited_by

      on !favorites.member?(post) do
        favorites.add(post)
        favorited_by.add(current_user)

        res.redirect "/search"
      end

      on favorites.member?(post) do
        on session[:origin] do
          session.delete(:origin)
          res.redirect "/search"
        end

        on default do
          favorites.delete(post)
          favorited_by.delete(current_user)

          res.redirect "/search"
        end
      end

      on default do
        res.redirect "/favorites"
      end
    end

    on "profile" do
      on post, param("developer") do |params|
        developer = current_developer

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

      on default do
        render("developer/profile", title: "Edit profile")
      end
    end

    on "logout" do
      logout(Developer)

      session[:success] = "You have successfully logged out!"
      res.redirect "/"
    end

    on "delete" do
      current_user.delete

      session[:success] = "You have deleted your account."
      res.redirect "/"
    end

    on default do
      render("developer/dashboard", title: "Dashboard")
    end
  end
end
