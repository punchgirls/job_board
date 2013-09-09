module AdminHelpers
  def current_admin
    authenticated(Admin)
  end

  def mote_vars(content)
    super.merge(current_admin: current_admin)
  end

  def notfound(msg)
    res.status = 404
    res.write(msg)
    halt(res.finish)
  end

  def forbidden(msg)
    res.status = 403
    res.write(msg)
    halt(res.finish)
  end
end
