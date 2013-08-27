require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678" })
end

scope do
  test "should inform User in case of incomplete fields" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/post/new", { post: {  title: "",
          description: "Ruby oracle needed!" }}

    assert last_response.body["All fields are required"]
  end

  test "should successfully post a new job offer" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/post/new", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    follow_redirect!

    assert last_response.body["You have successfully posted a job offer!"]
  end

  test "should display a list of posts" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/post/new", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    follow_redirect!

    assert last_response.body['<td colspan="4" id="post-title">']
  end

  test "should inform User of job deleted" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/post/new", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    post "/post/remove/1"

    follow_redirect!

    assert last_response.body["Post successfully removed!"]
  end

  test "should inform User of job edited" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/post/new", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    post "/post/edit/1", { post: {  title: "Ruby master",
          description: "Ruby oracle needed!" }}

    follow_redirect!

    assert last_response.body["Post successfully edited!"]

    assert last_response.body["Ruby master"]
  end
end
