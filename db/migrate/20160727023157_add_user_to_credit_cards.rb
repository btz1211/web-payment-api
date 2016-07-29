class AddUserToCreditCards < ActiveRecord::Migration
  def change
	add_column :credit_cards, :user_id, :integer
  end
end
