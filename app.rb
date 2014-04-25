Encoding.default_external = "UTF-8"

require "cuba"
require "cuba/contrib"
require "malone"
require "mote"
require "nobi"
require "ohm"
require "ohm/contrib"
require "ost"
require "rack/protection"
require "requests"
require "shield"
require "stripe"

APP_SECRET = ENV.fetch("APP_SECRET")
GITHUB_CLIENT_ID = ENV.fetch("GITHUB_CLIENT_ID")
GITHUB_CLIENT_SECRET = ENV.fetch("GITHUB_CLIENT_SECRET")
GITHUB_OAUTH_AUTHORIZE = ENV.fetch("GITHUB_OAUTH_AUTHORIZE")
GITHUB_OAUTH_ACCESS_TOKEN = ENV.fetch("GITHUB_OAUTH_ACCESS_TOKEN")
GITHUB_FETCH_USER = ENV.fetch("GITHUB_FETCH_USER")
MALONE_URL = ENV.fetch("MALONE_URL")
NOBI_SECRET=ENV.fetch("NOBI_SECRET")
REDIS_URL = ENV.fetch("OPENREDIS_URL")
RESET_URL = ENV.fetch("RESET_URL")
STRIPE_PUBLISHABLE_KEY = ENV.fetch("STRIPE_PUBLISHABLE_KEY")

Stripe.api_key = ENV.fetch("STRIPE_SECRET_KEY")

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::TextHelpers
Cuba.plugin Shield::Helpers

Ohm.connect(url: REDIS_URL)
Ost.connect(url: REDIS_URL)
Malone.connect(url: MALONE_URL, tls: false, domain: "punchgirls.com")

Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }
Dir["./helpers/**/*.rb"].each { |rb| require rb }
Dir["./filters/**/*.rb"].each { |rb| require rb }
Dir["./lib/**/*.rb"].each     { |rb| require rb }

Cuba.plugin CompanyHelpers
Cuba.plugin DeveloperHelpers
Cuba.plugin UserHelpers

Cuba.use Rack::Session::Cookie,
  key: "job_board",
  secret: APP_SECRET

Cuba.use Rack::Protection, except: :http_origin
Cuba.use Rack::Protection::RemoteReferrer

Cuba.use Rack::Static,
  urls: %w[/js /css /img],
  root: File.expand_path("./public", __dir__)

Cuba.define do
  persist_session!

  on root do
    res.redirect "/search?query=All+posts"
  end

  on "pricing" do
    render("pricing", title: "Pricing",
      plan_id: "small", background_img: true)
  end

  on "about" do
    render("about", title: "About",
      background_img: true)
  end

  on "help" do
    render("help", title: "Help")
  end

  on "contact" do
    run Contacts
  end

  on "terms" do
    render("terms", title: "Terms and Conditions")
  end

  on "privacy" do
    render("privacy", title: "Privacy Policy")
  end

  on authenticated(Company) do
    run Companies
  end

  on authenticated(Developer) do
    run Developers
  end

  on default do
    run Guests
  end
end
