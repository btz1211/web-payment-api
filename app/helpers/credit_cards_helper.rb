module CreditCardsHelper
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
