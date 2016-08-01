class CreditCard < ActiveRecord::Base

  #associations
  belongs_to :users

  #validations
  validates :cardNumber, presence: true
  validates :expirationMonth, presence: true
  validates :expirationYear, presence: true
  validates :cvc, presence: true
  validates :stripe_token, presence: true
end
