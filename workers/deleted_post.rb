require_relative "../app"

Ost[:deleted_post].each do |id|
  post = Post[id]

  post.developers.each do |developer|
    text = Mailer.render("deleted_post", post: post, developer: developer)

    Malone.deliver(
      from: "team@punchgirls.com",
      to: developer.email,
      subject: "[Job Board] " + post.title + " post has been removed",
      text: text)
  end

  post.delete
end
