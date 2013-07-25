require "cuba/test"
require_relative "../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234" })
end

scope do
  test "should inform User in case of incomplete fields" do
    get "/company_login"

    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234"}

    get "/dashboard"

    get "/post_job_offer"

    post "/post_job_offer", { post: {  title: "",
          description: "Ruby oracle needed!" }}

    assert last_response.body["All fields are required"]
  end

  test "should successfully post a new job offer" do
    get "/company_login"

    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234"}

    get "/dashboard"

    get "/post_job_offer"

    post "/post_job_offer", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    get "/dashboard"

    assert last_response.body["You have successfully posted a job offer!"]
  end

  test "should display a list of posts" do
    get "/company_login"

    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234"}

    get "/dashboard"

    get "/post_job_offer"

    post "/post_job_offer", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    get "/dashboard"

    assert last_response.body['<td colspan="3" id="post-title">']
  end

  test "should inform User of post deleted" do
    get "/company_login"

    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234"}

    get "/dashboard"

    get "/post_job_offer"

    post "/post_job_offer", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    get "/dashboard"

    get "/remove_post/1"

    assert last_response.body["Post successfully removed!"]
  end

  test "should inform User of post edited" do
    get "/company_login"

    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234"}

    get "/dashboard"

    get "/post_job_offer"

    post "/post_job_offer", { post: {  title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    get "/dashboard"

    get "/edit_post/1"

    post "/edit_post/1", { post: {  title: "Ruby master",
          description: "Ruby oracle needed!" }}

    get "/dashboard"

    assert last_response.body["Post successfully edited!"]
    assert last_response.body["Ruby master"]
  end
end
