require "cuba"
require "mote"
require "cuba/contrib"
require "rack/protection"
require "ohm"
require "shield"
require "requests"
require "malone"
require "ohm/contrib"
require "nobi"
require "stripe"

APP_SECRET = ENV.fetch("APP_SECRET")
REDIS_URL = ENV.fetch("OPENREDIS_URL")
GITHUB_CLIENT_ID = ENV.fetch("GITHUB_CLIENT_ID")
GITHUB_CLIENT_SECRET = ENV.fetch("GITHUB_CLIENT_SECRET")
GITHUB_OAUTH_AUTHORIZE = ENV.fetch("GITHUB_OAUTH_AUTHORIZE")
GITHUB_OAUTH_ACCESS_TOKEN = ENV.fetch("GITHUB_OAUTH_ACCESS_TOKEN")
GITHUB_FETCH_USER = ENV.fetch("GITHUB_FETCH_USER")
RESET_URL = ENV.fetch("RESET_URL")
Stripe.api_key = ENV.fetch("SECRET_KEY")

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::TextHelpers
Cuba.plugin Shield::Helpers

Ohm.connect(url: REDIS_URL)
Malone.connect

Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }

Dir["./helpers/**/*.rb"].each  { |rb| require rb }
Dir["./lib/**/*.rb"].each { |rb| require rb }

Cuba.plugin AdminHelpers
Cuba.plugin CompanyHelpers
Cuba.plugin DeveloperHelpers
Cuba.plugin UserHelpers

Cuba.use Rack::MethodOverride
Cuba.use Rack::Session::Cookie,
  key: "job_board",
  secret: APP_SECRET

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer

Cuba.use Rack::Static,
  urls: %w[/js /css /img],
  root: "./public"

Cuba.define do
  persist_session!

  on root do
    render("home", title: "Home")
  end

  on authenticated(Admin) do
    run Admins
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
