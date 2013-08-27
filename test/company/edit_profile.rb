require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678" })

  Company.create({ name: "Punchies",
          email: "punchies@mail.com",
          url: "http://www.punchies.com",
          password: "12345678" })
end

scope do
  test "should inform User of successful profile update" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "My Company",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "",
          password_confirmation: "" }}

    follow_redirect!

    assert last_response.body["My Company"]

    assert last_response.body["Your account was successfully updated!"]
  end

  test "should inform User in case of no name" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678" }}

    assert last_response.body["Company name is required"]
  end

  test "should inform User in case of invalid or missing email" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "Punchgirls",
          email: "punchgirlsmail.com",
          url: "http://www.punchgirls.com",
          password: "",
          password_confirmation: "" }}

    assert last_response.body["E-mail not valid"]
  end

  test "should inform User in case of e-mail already registered" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "Punchgirls",
          email: "punchies@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678" }}

    assert last_response.body["E-mail is already registered"]
  end

  test "should inform User in case of invalid or missing URL" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "Punchgirls",
          email: "punchies@mail.com",
          url: "ht://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678" }}

    assert last_response.body["URL not valid"]
  end

  test "should inform User in case of password not in range" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/edit/1", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "1234" }}

    assert last_response.body["The password must be at least 8 characters"]
  end

  test "should inform User in case of passwords not matching" do
    post "/login", { email: "punchgirls@mail.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12" }}

    assert last_response.body["Passwords don't match"]
  end
end
