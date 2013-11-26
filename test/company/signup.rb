require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush
end

scope do
  test "should display company signup" do
    get "/signup"

    assert_equal 200, last_response.status
  end

  test "should inform User in case of company name not provided" do
    post "/signup", { company: { name: "",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678",
          credits: "1" }, stripe_token: "stripe_6sJwbhd" }

    assert last_response.body["Company name is required"]
  end

  test "should inform User in case of email not valid" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirlsmail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678",
          credits: "1" }, stripe_token: "stripe_6sJwbhd" }

    assert last_response.body["E-mail not valid"]
  end

  test "should inform User of e-mail already registered" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678",
          credits: "1" }, stripe_token: "stripe_6sJwbhd" }

    get "/logout"

    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678",
          credits: "1" }, stripe_token: "stripe_6sJhsddkhs" }

    assert last_response.body["This e-mail is already registered"]
  end

  test "should inform User in case of URL not valid" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://ww.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678",
          credits: "1" }, stripe_token: "stripe_6sJwbhd" }

    assert last_response.body["URL not valid"]
  end

  test "should inform User in case of password not in range" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "1234",
          credits: "1" }, stripe_token: "stripe_6sJwbhd" }

    assert last_response.body["The password length must be at least 6 characters"]
  end

  test "should inform User in case of password not matching" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234567",
          password_confirmation: "12345678",
          credits: "1" }, stripe_token: "stripe_6sJwbhd" }

    assert last_response.body["Passwords don't match"]
  end

  test "should inform User of successful signup and logout" do
    post "/signup", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678",
          credits: "1" }, stripe_token: "stripe_6sJwbhd" }

    follow_redirect!

    assert last_response.body["You have successfully signed up!"]

    get "/logout"

    follow_redirect!

    assert last_response.body["You have successfully logged out!"]
  end
end
