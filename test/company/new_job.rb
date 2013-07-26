require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234" })
end

scope do
  test "should inform User in case of incomplete fields" do
    post "/login", { email: "punchgirls@mail.com",
          password: "1234" }

    get "/jobs/new"

    post "/jobs/new", { post: {  title: "",
          description: "Ruby oracle needed!" }}

    assert last_response.body["All fields are required"]
  end

  test "should successfully post a new job offer" do
    post "/login", { email: "punchgirls@mail.com",
          password: "1234" }

    post "/jobs/new", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    get "/dashboard"

    assert last_response.body["You have successfully posted a job offer!"]
  end

  test "should display a list of posts" do
    post "/login", { email: "punchgirls@mail.com",
          password: "1234" }

    post "/jobs/new", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    get "/dashboard"

    assert last_response.body['<td colspan="3" id="post-title">']
  end

  test "should inform User of job deleted" do
    post "/login", { email: "punchgirls@mail.com",
          password: "1234" }

    post "/jobs/new", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    get "/dashboard"

    get "/jobs/remove/1"

    get "/dashboard"

    assert last_response.body["Post successfully removed!"]
  end

  test "should inform User of job edited" do
    post "/login", { email: "punchgirls@mail.com",
          password: "1234" }

    post "/jobs/new", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    get "/dashboard"

    get "/jobs/edit/1"

    post "/jobs/edit/1", { post: {  title: "Ruby master",
          description: "Ruby oracle needed!" }}

    get "/dashboard"

    assert last_response.body["Post successfully edited!"]

    assert last_response.body["Ruby master"]
  end
end
