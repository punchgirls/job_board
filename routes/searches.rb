class Searches < Cuba
  define do
    query = session[:query]

    on get, param("post") do |params|
      posts = Search.posts(params)

      session[:query] = params
      render("search", title: "Tags", posts: posts)
    end

    on param "all" do |params|
      session[:query] = { "all"=>"true" }
      render("search", title: "Search", posts: Post.all)
    end

    on param "company" do
      session[:error] = "You have to login as developer to
        perform this action"
      render("search", title: "Search", posts: Post.all)
    end

    on query do
      if query.include?("all")
        session.delete(:query)
        render("search", title: "Search", posts: Post.all)
      else
        posts = Search.posts(session[:query])
        session.delete(:query)

        render("search", title: "Tags", posts: posts)
      end
    end

    on default do
      render("search", title: "Search", posts: nil)
    end
  end
end
