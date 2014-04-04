class Searches < Cuba
  define do
    on get, param("query") do |query|
      on query.include?("All posts") do
        render("search", title: "Search",
          posts: Post.active.sort_by(:date, order: "ALPHA DESC"),
          search: true, profile: true, query: "All posts", all_posts_link: true)
      end

      on default do
        posts = Search.posts(query)

        render("search", title: "Search",
          posts: posts.sort_by(:date, order: "ALPHA DESC"),
          search: true, profile: true, query: query, all_posts_link: true)
      end
    end

    on param "company_id" do |id|
      render("search", title: "Search",
        posts: Post.active.find(company_id: id).sort_by(:date, order: "ALPHA DESC"),
        search: true, profile: true, all_posts_link: true)
    end

    on param "post_id" do |id|
      post = Post[id]

      on post && post.published? do
        render("search", title: "Search",
          posts: [post], search: true, profile: true, all_posts_link: true)
      end

      on default do
        render("search", title: "Search",
          posts: nil, search: true, profile: true, all_posts_link: true)
      end
    end

    on default do
      render("search", title: "Search",
        posts: nil, search: true, profile: true, all_posts_link: true)
    end
  end
end
