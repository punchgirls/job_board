class Searches < Cuba
  define do
    on default do
      on get, param("tags") do |tags|
        posts = Search.tags(tags)

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
end
