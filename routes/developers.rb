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

      params = { date: time,
        developer_id: current_developer.id,
        post_id: id }

      application = Application.create(params)

      session[:success] = "You have successfully applied for a job!"

      on param("origin") do |origin|
        if origin == "favorites"
          res.redirect "/favorites"
        elsif origin == "applications"
          res.redirect "/applications"
        elsif origin == "search"
          res.redirect "/applications"
        end
      end

      on default do
        res.redirect "/dashboard"
      end
    end

    on "favorite/:id" do |id|
      query = session[:query]
      origin = session[:origin]
      post = Post[id]

      if current_user.favorites.member?(post) && !origin
        current_user.favorites.delete(post)
        post.favorited_by.delete(current_user)
      end

      if current_user.favorites.member?(post) && origin
        session.delete(:origin)
        session.delete(:query)
      end

      if current_user.favorites.add(post)
        post.favorited_by.add(current_user)
        session[:success] = "You have added a post to your favorites!"
      end

      on default do
        if query
          posts = Search.posts(query)

          session.delete(:query)
          render("search", title: "Search", posts: posts)
        else
          res.redirect "/favorites"
        end
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

    on "delete/:id" do |id|
      Developer[id].delete

      session[:success] = "You have deleted your account."
      res.redirect "/"
    end

    on default do
      render("developer/dashboard", title: "Dashboard")
    end
  end
end
