require "cuba"
require "mote"
require "cuba/contrib"
require "rack/protection"
require "ohm"
require "shield"

APP_SECRET = ENV.fetch("APP_SECRET")
REDIS_URL = ENV.fetch("REDIS_URL")

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::TextHelpers
Cuba.plugin Shield::Helpers

Ohm.connect(url: REDIS_URL)

Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }

Dir["./helpers/**/*.rb"].each  { |rb| require rb }

Cuba.plugin Cuba::Helpers

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

  on authenticated(Company) do
    run Companies
  end

  on default do
    run Guests
  end
end
