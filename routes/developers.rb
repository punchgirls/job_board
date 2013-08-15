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
      res.redirect "/dashboard"
    end

    on "favorite/:id" do |id|
      post = Post[id]

      if current_user.favorites.member?(post)
        current_user.favorites.delete(post)
      else
        current_user.favorites.add(post)
        session[:success] = "You have added a post to your favorites!"
      end

      on param("origin") do |origin|
        if origin == "favorites"
          res.redirect "/favorites"
        else
          res.redirect "/dashboard"
        end
      end

      on default do
        res.redirect "/dashboard"
      end
    end

    on "profile" do
      on post, param("developer") do |params|
        login = DeveloperLogin.new(params)

        on login.valid? do
          current_developer.update(params)

          session[:success] = "Your account was successfully updated!"
          res.redirect "/dashboard"
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

    on default do
      render("developer/dashboard", title: "Dashboard")
    end
  end
end
