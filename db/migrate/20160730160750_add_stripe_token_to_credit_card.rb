class AddStripeTokenToCreditCard < ActiveRecord::Migration
  def change
	add_column :credit_cards, :stripe_token, :string
  end
end
