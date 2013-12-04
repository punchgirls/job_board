module Mailer
  extend Mote::Helpers

  def self.render(template, params = {})
    mote("mails/%s.md" % template, params)
  end

  def self.deliver(email, subject, text, replyto = "")
    Malone.deliver(to: email, subject: subject, text: text,
      replyto: replyto)
  end
end
