class UpdateCreditCard < ActiveRecord::Migration
  def change
	change_column :credit_cards, :expirationDate, :string
  end
end
