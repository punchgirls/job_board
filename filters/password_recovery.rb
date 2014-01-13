class PasswordRecovery < Scrivener
  attr_accessor :password, :password_confirmation

  def validate
    assert password.length > 5, [:password, :too_small]
    assert password == password_confirmation, [:password, :not_confirmed]
  end
end
