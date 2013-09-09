class Admins < Cuba
  define do
    on "companies" do
      render("admin/companies", title: "Companies")
    end

    on "posts/:id" do |id|
      company = Company[id]
      posts = company.posts
      render("admin/companies/posts", title: "Posts",
        company: company, posts: posts)
    end

    on "applications/:id" do |id|
      post = Post[id]
      company = post.company
      applications = post.applications

      render("admin/companies/applications", title: "Applications",
        company: company, applications: applications)
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
