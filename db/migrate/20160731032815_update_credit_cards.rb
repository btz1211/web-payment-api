class UpdateCreditCards < ActiveRecord::Migration
  def change
	remove_column :credit_cards, :expirationDate
	add_column :credit_cards, :expirationYear, :string
	add_column :credit_cards, :expirationMonth, :string
  end
end
