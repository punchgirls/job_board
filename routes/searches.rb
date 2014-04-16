class Searches < Cuba
  define do
    on get, param("query") do |query|
      on query.include?("All posts") do
        posts = Post.active
        locations = Location.count(posts)

        on param("location") do |location|
          if location == "Work from anywhere"
            posts = posts.find(remote: "true")
          else
            posts = posts.find(location: location)
          end

          render("search", title: "Search",
            posts: posts.sort_by(:date, order: "ALPHA DESC"),
            locations: locations, location: location,
            query: "All posts", all_posts_link: true)
        end

        render("search", title: "Search",
          posts: posts.sort_by(:date, order: "ALPHA DESC"),
          locations: locations, query: "All posts", all_posts_link: true)
      end

      on default do
        posts = Search.posts(query)
        locations = Location.count(posts)

        on param("location") do |location|
          if location == "Work from anywhere"
            posts = posts.find(remote: "true")
          else
            posts = posts.find(location: location)
          end

          render("search", title: "Search",
            posts: posts.sort_by(:date, order: "ALPHA DESC"),
            locations: locations, location: location,
            query: query, all_posts_link: true)
        end

        render("search", title: "Search",
          posts: posts.sort_by(:date, order: "ALPHA DESC"),
            locations: locations, query: query, all_posts_link: true)
      end
    end

    on param "company_id" do |id|
      render("search", title: "Search",
        posts: Post.active.find(company_id: id).sort_by(:date, order: "ALPHA DESC"),
        all_posts_link: true)
    end

    on param "post_id" do |id|
      post = Post[id]

      on post && post.published? do
        render("search", title: "Search",
          posts: [post], all_posts_link: true)
      end

      on default do
        render("search", title: "Search",
          all_posts_link: true)
      end
    end

    on param("location") do |location|
      posts = Post.active
      locations = Location.count(posts)

      if location == "Work from anywhere"
        posts = posts.find(remote: "true")
      else
        posts = posts.find(location: location)
      end

      render("search", title: "Search",
        posts: posts.sort_by(:date, order: "ALPHA DESC"),
        locations: locations, location: location,
        query: "All posts", all_posts_link: true)
    end

    on default do
      render("search", title: "Search",
        all_posts_link: true)
    end
  end
end
