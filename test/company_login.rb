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
  test "should display company login" do
    get "/company_login"

    assert_equal 200, last_response.status
  end

  test "should inform User in case of invalid login information" do
    post "/company_login", { email: "punchies@mail.com",
          password: "1234" }

    assert last_response.body["Invalid email and/or password combination"]
  end

  test "should inform User of successful login" do
    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234" }

    get "/dashboard"

    assert last_response.body["You have successfully logged in!"]
  end
end
