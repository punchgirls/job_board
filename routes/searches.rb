class Searches < Cuba
  define do
    on get, param("query") do |query|
      on query.include?("All posts") do
        posts = Post.active
        locations = Location.count(posts)

        on param "location" do |location|
          if location == "Work from anywhere"
            posts = posts.find(remote: "true")
          else
            posts = posts.find(location: location)
          end

          render("search", title: "Search",
            posts: posts.sort_by(:date, order: "ALPHA DESC"),
            locations: locations, query: "All+posts", all_posts_link: true)
        end

        render("search", title: "Search",
          posts: posts.sort_by(:date, order: "ALPHA DESC"),
          locations: locations, query: "All+posts", all_posts_link: true)
      end

      on default do
        posts = Search.posts(query)
        locations = Location.count(posts)

        on param "location" do |location|
          if location == "Work from anywhere"
            posts = posts.find(remote: "true")
          else
            posts = posts.find(location: location)
          end

          render("search", title: "Search",
            posts: posts.sort_by(:date, order: "ALPHA DESC"),
            locations: locations, query: query, all_posts_link: true)
        end

        render("search", title: "Search",
          posts: posts.sort_by(:date, order: "ALPHA DESC"),
            locations: locations, query: query, all_posts_link: true)
      end
    end

    on param "company_id" do |id|
      locations = Location.count(Post.all)

      render("search", title: "Search",
        posts: Post.active.find(company_id: id).sort_by(:date, order: "ALPHA DESC"),
        locations: locations, all_posts_link: true)
    end

    on param "post_id" do |id|
      post = Post[id]

      locations = Location.count(Post.all)

      on post && post.published? do
        render("search", title: "Search", locations: locations,
          posts: [post], all_posts_link: true)
      end

      on default do
        render("search", title: "Search", locations: locations,
          posts: nil, all_posts_link: true)
      end
    end

    on default do
      render("search", title: "Search",
        posts: nil, all_posts_link: true)
    end
  end
end
