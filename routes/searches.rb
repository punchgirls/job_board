class Searches < Cuba
  define do
    on param "all" do |params|
      render("search", title: "Search", posts: Post.active)
    end

    on get, param("tags") do |tags|
      posts = Search.posts(tags)

<<<<<<< HEAD
      render("search", title: "Test", tags: tags, posts: posts)
    end

    on param "company_id" do |id|
      render("search", title: "Search", posts: Post.active.find(company_id: id))
=======
      session[:query] = tags
      render("search", title: "Search", posts: posts, search: true)
    end

    on param "all" do |params|
      session[:query] = { "all"=>"true" }
      render("search", title: "Search", posts: Post.all, search: true)
    end

    on param "company_id" do |id|
      render("search", title: "Search", posts: Post.find(company_id: id),
        search: true)
>>>>>>> 7a886fe55abf85a1951c25074ce43c1c40f91f69
    end

    on param "post_id" do |id|
      render("search", title: "Search", posts: [Post[id]], search: true)
    end

<<<<<<< HEAD
=======
    on param "company" do
      session[:error] = "You have to login as developer to
        perform this action"
      render("search", title: "Search", posts: Post.all, search: true)
    end

    on query do
      if query.include?("all")
        session.delete(:query)
        render("search", title: "Search", posts: Post.all, search: true)
      else
        posts = Search.posts(session[:query])
        session.delete(:query)

        render("search", title: "Search", posts: posts, search: true)
      end
    end

>>>>>>> 7a886fe55abf85a1951c25074ce43c1c40f91f69
    on default do
      render("search", title: "Search", posts: nil, search: true)
    end
  end
end