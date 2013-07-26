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
  test "should display company profile" do
    get "/login"

    post "/login", { email: "punchgirls@mail.com",
          password: "1234" }

    get "/profile"

    assert last_response.body["punchgirls@mail.com"]
  end
end
