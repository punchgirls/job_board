class PasswordRecovery < Scrivener
  attr_accessor :password, :password_confirmation

  def validate
    assert_length :password, 8..32
    assert password == password_confirmation, [:password, :not_confirmed]
  end
end
