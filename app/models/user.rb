class User < ActiveRecord::Base

  #associations
  has_many :credit_cards, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
