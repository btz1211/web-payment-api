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

  def create_credit_card(user, credit_card_params)
    customer = Stripe::Customer.create(
      :source => credit_card_params[:stripeToken],
      :description => "card for #{user.email}"
    )

    CreditCard.new(cardNumber: credit_card_params[:cardNumber],
                   expirationMonth: credit_card_params[:expirationMonth],
                   expirationYear: credit_card_params[:expirationYear],
                   cvc: credit_card_params[:cvc],
                   stripe_token: customer.id);

  end

end
