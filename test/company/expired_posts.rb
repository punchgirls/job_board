require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678" })

  Post.create({ date: "1370833200",
          expiration_date: "1373511600",
          title: "Ruby developer",
          description: "Ruby ninja needed!",
          company_id: "1" })
end

scope do
  test "Should not list expired job posts" do
    get "/posts"

    assert !last_response.body["Ruby ninja needed"]
  end
end
