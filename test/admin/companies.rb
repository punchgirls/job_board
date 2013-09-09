require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Admin.create({ email: "team@punchgirls.com",
          password: "12345678" })

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678" })

  Company.create({ name: "Punchies",
          email: "punchies@mail.com",
          url: "http://www.punchies.com",
          password: "12345678" })

  time = Time.new.to_i

  Post.create({ date: time,
    expiration_date: time + (30 * 24 * 60 * 60),
    tags: "Ruby",
    title: "Ruby developer",
    description: "Lorem ipsum dolor sit amet,
    consectetur adipiscing elit. Morbi condimentum,
    odio at fringilla commodo, tellus nisi bibendum
    ",
    company_id: "1" })
end

scope do
  test "should display company listing" do
    post "/admin", { email: "team@punchgirls.com",
          password: "12345678" }

    follow_redirect!

    get "/companies"

    assert_equal 200, last_response.status

    assert last_response.body["Punchgirls"]
  end

  test "should successfully edit company" do
    post "/admin", { email: "team@punchgirls.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "My Company",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "",
          password_confirmation: "" }}

    follow_redirect!

    assert last_response.body["Company was successfully updated!"]
  end

  test "should inform in case of missing company name" do
    post "/admin", { email: "team@punchgirls.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678" }}

    assert last_response.body["Company name is required"]
  end

  test "should inform in case of invalid or missing email" do
    post "/admin", { email: "team@punchgirls.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "Punchgirls",
          email: "punchgirlsmail.com",
          url: "http://www.punchgirls.com",
          password: "",
          password_confirmation: "" }}

    assert last_response.body["E-mail not valid"]
  end

  test "should inform in case of e-mail already registered" do
    post "/admin", { email: "team@punchgirls.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "Punchgirls",
          email: "punchies@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678" }}

    assert last_response.body["E-mail is already registered"]
  end

  test "should inform in case of invalid or missing URL" do
    post "/admin", { email: "team@punchgirls.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "Punchgirls",
          email: "punchies@mail.com",
          url: "ht://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12345678" }}

    assert last_response.body["URL not valid"]
  end

  test "should inform in case of password not in range" do
    post "/admin", { email: "team@punchgirls.com",
          password: "12345678" }

    post "/edit/1", { company: { name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "1234",
          password_confirmation: "1234" }}

    assert last_response.body["The password length must be between 8 to 32 characters"]
  end

  test "should inform in case of passwords not matching" do
    post "/admin", { email: "team@punchgirls.com",
          password: "12345678" }

    post "/edit/1", { company: {
          name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678",
          password_confirmation: "12" }}

    assert last_response.body["Passwords don't match"]
  end

  test "should delete company and all related posts" do
    post "/admin", { email: "team@punchgirls.com",
          password: "12345678" }

    get "/company/1/delete"

    follow_redirect!
    assert Post.all.empty?
    assert last_response.body["You have deleted the company account."]
  end
end
