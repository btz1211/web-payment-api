class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :cardNumber
      t.date :expirationDate
      t.string :cvc

      t.timestamps null: false
    end
  end
end
