class Prime::Near::AccountDecorator < Prime::AccountDecorator
  def balance
    details.balance.to_f / (10 ** factor)
  end
end
