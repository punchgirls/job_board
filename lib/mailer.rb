module Mailer
  extend Mote::Helpers

  def self.render(template, params = {})
    mote("mails/%s.md" % template, params)
  end
end
