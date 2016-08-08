module CreditCardsHelper
  def create_credit_card(credit_card_info)
    customer = Stripe::Customer.create(
      :source => credit_card_info[:stripeToken],
      :description => "card for #{credit_card_info[:name]}"
    )

    CreditCard.new(cardNumber: credit_card_info[:cardNumber],
                   expirationMonth: credit_card_info[:expirationMonth],
                   expirationYear: credit_card_info[:expirationYear],
                   cvc: credit_card_info[:cvc],
                   stripe_token: customer.id);

  end
  
  def charge_card(credit_card, amount, charge_description)
    begin
      if amount >= 50
        charge = Stripe::Charge.create(
          :amount => amount,
          :currency => "usd",
          :customer => credit_card[:stripe_token],
          :description => charge_description
        )

        return charge
      else
        raise "invalid charge amount: #{amount}, please provide amount in cents (i.e 100 is a $1), and at least 50 cents"
      end
    rescue Stripe::CardError => e
      raise "unable to charge due to: #{e}"
    end
  end
end
