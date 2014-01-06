class Searches < Cuba
  define do
    query = session[:query]

    on get, param("tags") do |tags|
      posts = Search.posts(tags)

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
    end

    on param "post_id" do |id|
      render("search", title: "Search", posts: [Post[id]], search: true)
    end

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

    on default do
      render("search", title: "Search", posts: nil, search: true)
    end
  end
end