module ApplicationHelper
  def convert_error_hash_to_array(error_object)
    errors = []

    error_object.each do |key|
      error_object[key].each do |attr_error|
        errors.push("#{key}: #{attr_error}")
      end
    end

    errors
  end

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

end
