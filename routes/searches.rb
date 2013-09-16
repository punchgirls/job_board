class Searches < Cuba
  define do
    on get, param("post") do |params|
      posts = Search.posts(params)

      render("search", title: "Tags", posts: posts)
    end

    on param "all" do
      render("search", title: "Search", posts: Post.all)
    end

    on param "company" do
      session[:error] = "You have to login as developer to
        perform this action"
      render("search", title: "Search", posts: Post.all)
    end

    on default do
      render("search", title: "Search", posts: nil)
    end
  end
end
