require "cuba/test"
require_relative "../../app"

prepare do
  Ohm.flush

  Company.create({ name: "Punchgirls",
          email: "punchgirls@mail.com",
          url: "http://www.punchgirls.com",
          password: "12345678" })
end

scope do
  test "should display forgot password page" do
    get "/forgot-password"

    assert_equal 200, last_response.status
  end

  test "should send an email with a signature link and password recovery instructions" do
    post "/forgot-password", { email: "punchgirls@mail.com" }

    follow_redirect!

    follow_redirect!

    assert last_response.body["Check your e-mail and follow the instructions."]
  end

  test "should inform user of e-mail not found" do
    post "/forgot-password", { email: "punchies@mail.com"}

    follow_redirect!

    assert last_response.body["Can't find a user with that e-mail."]
  end

  test "should take the user to the reset password page" do
    nobi = Nobi::TimestampSigner.new('my secret here')
    signature = nobi.sign(String(1))

    post "/otp/#{signature}", { company: { password: "123456789",
          password_confirmation: "123456789" }}

    follow_redirect!

    assert last_response.body["You have successfully changed"]

    get "/logout"
  end

  test "should inform user of non matching passwords" do
    nobi = Nobi::TimestampSigner.new('my secret here')
    signature = nobi.sign(String(1))

    post "/otp/#{signature}", { company: { password: "123456789",
          password_confirmation: "123456" }}

    assert last_response.body["Passwords don't match"]
  end

  test "should inform user of password not in range" do
    nobi = Nobi::TimestampSigner.new('my secret here')
    signature = nobi.sign(String(1))

    post "/otp/#{signature}", { company: { password: "123456",
          password_confirmation: "123456" }}

    assert last_response.body["The password length must be between 8 to 32 characters"]
  end

  test "should inform user of password not in range" do
    nobi = Nobi::TimestampSigner.new('my secret here')
    signature = nobi.sign(String(1))

    post "/otp/#{signature}", { company: { password: "123456",
          password_confirmation: "1234" }}

    assert last_response.body["The password length must be between 8 to 32 characters"]
  end

  test "should inform user of invalid signature" do
    get "/otp/1.BP5Oig.MUzCH8oBfJANZ-oZh3PRKQ32Pzc"

    follow_redirect!

    assert last_response.body["Invalid URL. Please try again!"]
  end
end
