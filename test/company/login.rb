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
  test "should display company login" do
    get "/login"

    assert_equal 200, last_response.status
  end

  test "should inform User in case of invalid login information" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "12345678" }}

    assert last_response.body["Invalid email/password combination"]
  end

  test "should inform User of successful login" do
    post "/login", { company: { email: "punchgirls@mail.com",
      password: "123456" }}

    follow_redirect!

    assert last_response.body["You have successfully logged in!"]
  end
end
