class Searches < Cuba
  define do
    on param "all" do |params|
      render("search", title: "Search", posts: Post.active)
    end

    on get, param("tags") do |tags|
      posts = Search.posts(tags)

      render("search", title: "Test", tags: tags, posts: posts)
    end

    on param "company_id" do |id|
      render("search", title: "Search", posts: Post.active.find(company_id: id))
    end

    on param "post_id" do |id|
      render("search", title: "Search", posts: [Post[id]])
    end

    on default do
      render("search", title: "Search", posts: nil)
    end
  end
end