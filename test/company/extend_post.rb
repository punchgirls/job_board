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

  Post.create({ date: "1377621143",
          expiration_date: "1380213143",
          tags: "Ruby, Cuba",
          location: "New York, NY",
          title: "Ruby developer",
          description: "Ruby ninja needed!",
          company_id: "1" })
end

scope do
  test "should inform User of successful 14 days extension" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/extend/1", { post: { days: 15 }}

    follow_redirect!

    assert last_response.body["by 15 days!"]
  end

  test "should inform User of successful 30 days extension" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    post "/post/extend/1", { post: { days: 30 }}

    follow_redirect!

    assert last_response.body["by 30 days!"]
  end
end
