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

  test "should inform User in case of company name not provided" do
    post "/signup", { company: { name: "",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "1234" }}

    assert last_response.body["Company name is required"]
  end

  test "should inform User in case of email not valid" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirlsmail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "1234" }}

    assert last_response.body["E-mail not valid"]
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

  test "should inform User in case of URL not valid" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls",
          password: "1234",
          password_confirmation: "1234" }}

    assert last_response.body["URL not valid"]
  end

  test "should inform User in case of password not present" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "",
          password_confirmation: "" }}

    assert last_response.body["Password not present"]
  end

  test "should inform User in case of password not matching" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "123" }}

    assert last_response.body["Passwords don't match"]
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
end
