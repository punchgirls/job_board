class Searches < Cuba
  define do
    on get, param("query") do |query|

      on query.include?("All posts") do
        render("search", title: "Search", posts: Post.active,
          search: true, query: "All posts", profile: true)
      end

      on default do
        posts = Search.posts(query)

        render("search", title: "Search", query: query, posts: posts,
          search: true, profile: true)
      end
    end

    on param "company_id" do |id|
      render("search", title: "Search",
        posts: Post.active.find(company_id: id), search: true,
        profile: true)
    end

    on param "post_id" do |id|
      post = Post[id]

      on post do
        render("search", title: "Search", posts: [post],
          search: true, search: true, profile: true)
      end

      on default do
        render("search", title: "Search", posts: nil, search: true,
          profile: true)
      end
    end

    on default do
      render("search", title: "Search", posts: nil, search: true,
        profile: true)
    end
  end
end
