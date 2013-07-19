require "cuba"
require "mote"
require "cuba/contrib"
require "rack/protection"

APP_SECRET = ENV.fetch("APP_SECRET")

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::TextHelpers

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
  on root do
    render("home", title: "Home")
  end
end
