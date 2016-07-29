class CreditCard < ActiveRecord::Base

  #associations
  belongs_to :users

  #validations
  validates :cardNumber, :presence => true
  validates :expirationDate, :presence => true
  validates :cvc, :presence => true
end
