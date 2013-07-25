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
  test "should display company account" do
    get "/company_login"

    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234" }

    get "/company_account"

    assert last_response.body["punchgirls@mail.com"]
  end
end
