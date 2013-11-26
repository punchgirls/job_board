require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
    email: "punchgirls@mail.com",
    url: "http://www.punchgirls.com",
    password: "123456",
    credits: "8",
    customer_id: "cus_2wnQ01IoAywTZz" })
end

scope do
  test "should inform User of no tags" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/new", { post: { tags: "",
          location: "New York, NY",
          title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    assert last_response.body["At least one skill is required"]
  end

  test "should inform User of missing title" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/new", { post: { tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "",
          description: "Ruby oracle needed!" }}

    assert last_response.body["Title is required"]
  end

  test "should inform User of missing description" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/new", { post: { tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "Ruby developer",
          description: "" }}

    assert last_response.body["Description is required"]
  end

  test "should successfully post a new job offer" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/new", { post: {  tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    follow_redirect!

    assert last_response.body["You have successfully posted a job offer!"]
  end

  test "should display a list of posts" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/new", { post: {  tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    follow_redirect!

    assert last_response.body['<ul id="posts-list">']
  end

  test "should inform User of job deleted" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/new", { post: {  tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "Ruby developer",
          description: "Ruby oracle needed!" }}

    post "/post/remove/1"

    follow_redirect!

    assert last_response.body["Post successfully removed!"]
  end
end
