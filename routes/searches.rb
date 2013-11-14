class Searches < Cuba
  define do
    query = session[:query]

    on root do
      render("search", title: "Search", posts: nil)
    end

    on get, param("post") do |params|
      on root do
        posts = Search.posts(params)

        session[:query] = params
        render("search", title: "Tags", posts: posts)
      end

      on(default) { not_found! }
    end

    on param "all" do |params|
      on root do
        session[:query] = { "all"=>"true" }
        render("search", title: "Search", posts: Post.all)
      end

      on(default) { not_found! }
    end

    on param "company" do
      on root do
        session[:error] = "You have to login as developer to
          perform this action"
        render("search", title: "Search", posts: Post.all)
      end

      on(default) { not_found! }
    end

    on query do
      on root do
        if query.include?("all")
          session.delete(:query)
          render("search", title: "Search", posts: Post.all)
        else
          posts = Search.posts(session[:query])
          session.delete(:query)

          render("search", title: "Tags", posts: posts)
        end
      end

      on(default) { not_found! }
    end

    on(default) { not_found! }
  end
end
