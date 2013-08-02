require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush
end

scope do
  test "should display homepage" do
    get "/"

    assert_equal 200, last_response.status
  end

  test "should display company signup" do
    get "/signup"

    assert_equal 200, last_response.status
  end

  test "should inform User in case of incomplete or invalid fields" do
    post "/signup", { company: { name: "",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "1234" }}

    assert last_response.body["All fields are required and must be valid"]
  end

  test "should inform User of successful signup and logout" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "1234" }}

    follow_redirect!

    assert last_response.body["You have successfully signed up!"]

    get "/logout"

    follow_redirect!

    assert last_response.body["You have successfully logged out!"]
  end

  test "should inform User of e-mail already registered" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "1234" }}

    get "/logout"

    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "1234" }}

    assert last_response.body["This e-mail is already registered"]
  end
end
