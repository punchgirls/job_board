class Searches < Cuba
  define do
    on param "all" do |params|
      render("search", title: "Search", posts: Post.active,
        search: true)
    end

    on get, param("tags") do |tags|
      posts = Search.posts(tags)

      render("search", title: "Test", tags: tags, posts: posts,
        search: true)
    end

    on param "company_id" do |id|
      render("search", title: "Search",
        posts: Post.active.find(company_id: id), search: true)
    end

    on param "post_id" do |id|
      render("search", title: "Search", posts: [Post[id]],
        search: true, search: true)
    end

    on default do
      render("search", title: "Search", posts: nil, search: true)
    end
  end
end