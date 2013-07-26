module CompanyHelpers
  def current_company
    authenticated(Company)
  end

  def mote_vars(content)
    super.merge(current_company: current_company)
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