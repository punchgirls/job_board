require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Admin.create({ email: "team@punchgirls.com",
          password: "12345678" })
end

scope do
  test "should display admin login" do
    get "/admin"

    assert_equal 200, last_response.status
  end

  test "should inform User in case of invalid login information" do
    post "/admin", { email: "punchies@mail.com",
          password: "12345678" }

    assert last_response.body["Invalid email/password combination"]
  end

  test "should inform User of successful login" do
    post "/admin", { email: "team@punchgirls.com",
          password: "12345678" }

    follow_redirect!

    assert last_response.body["You have successfully logged in!"]
  end
end
