class Rent < TransactionType

  before_validation(:on => :create) do
    self.price_field ||= 1
  end

end