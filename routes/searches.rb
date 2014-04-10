class Searches < Cuba
  define do
    on get, param("query") do |query|
      on query.include?("All posts") do
        posts = Post.active.sort_by(:date, order: "ALPHA DESC")

        locations = Location.count(posts)

        render("search", title: "Search",
          posts: posts, locations: locations,
          search: true, profile: true, query: "All posts", all_posts_link: true)
      end

      on default do
        posts = Search.posts(query)

        locations = Location.count(posts)

        render("search", title: "Search",
          posts: posts.sort_by(:date, order: "ALPHA DESC"),
            locations: locations, search: true,
            profile: true, query: query, all_posts_link: true)
      end
    end

    on param "company_id" do |id|
      locations = Location.count(Post.all)

      render("search", title: "Search",
        posts: Post.active.find(company_id: id).sort_by(:date, order: "ALPHA DESC"),
        locations: locations, search: true, profile: true, all_posts_link: true)
    end

    on param "post_id" do |id|
      post = Post[id]

      locations = Location.count(Post.all)

      on post && post.published? do
        render("search", title: "Search", locations: locations,
          posts: [post], search: true, profile: true, all_posts_link: true)
      end

      on default do
        render("search", title: "Search", locations: locations,
          posts: nil, search: true, profile: true, all_posts_link: true)
      end
    end

    on param "location" do |location|
      if location == "Work from anywhere"
        posts = Post.active.find(remote: "true").sort_by(:date, order: "ALPHA DESC")
      else
        posts = Post.active.find(location: location).sort_by(:date, order: "ALPHA DESC")
      end

      locations = Location.count(Post.all)

      render("search", title: "Search",
        posts: posts, locations: locations,
        search: true, profile: true, all_posts_link: true)
    end

    on default do
      render("search", title: "Search",
        posts: nil, search: true, profile: true, all_posts_link: true)
    end
  end
end
