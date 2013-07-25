require "cuba/test"
require_relative "../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234" })

  Company.create({ name: "Punchies",
          email: "punchies@mail.com",
          url: "http://www.punchies.com",
          password: "1234" })
end

scope do
  test "should inform User of successful account update" do
    get "/company_login"

    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234" }

    get "/company_account"

    get "/edit_company_account/1"

    assert_equal 200, last_response.status

    post "/edit_company_account/1", { company: {
          name: "My Company",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "",
          password_confirmation: "" }}

    get "/company_account"

    assert last_response.body["My Company"]

    assert last_response.body["Your account was successfully updated!"]
  end

  test "should inform User in case of incomplete or invalid fields" do
    get "/company_login"

    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234" }

    get "/company_account"

    post "/edit_company_account/1", { company: {
          name: "",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "",
          password_confirmation: "" }}

    assert last_response.body["Name, E-mail and URL are required and must be valid"]
  end

  test "should inform User in case of passwords not matching" do
    get "/company_login"

    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234" }

    get "/company_account"

    post "/edit_company_account/1", { company: {
          name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "123",
          password_confirmation: "12" }}

    assert last_response.body["Passwords don't match"]
  end

  test "should inform User in case of e-mail already registered" do
    get "/company_login"

    post "/company_login", { email: "punchgirls@mail.com",
          password: "1234" }

    get "/company_account"

    post "/edit_company_account/1", { company: {
          name: "Punchgirls",
          email: "punchies@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "1234" }}

    assert last_response.body["E-mail is already registered"]
  end
end
