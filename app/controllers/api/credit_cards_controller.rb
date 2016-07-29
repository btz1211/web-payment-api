module Api
  class CreditCardsController < ApplicationController
    before_action  :get_user, :only => [:new]
    def index
    end

    def show
    end

    def new
      user = get_user()

      if user
        credit_card = create_credit_card();

        if credit_card.valid?
          #call stripe api to create card

          #save credit card data
          credit_card.save()
          user.credit_cards.add(credit_card)

          render json: credit_card.to_json([:stripe_token])

        else
          errors = convert_error_hash_to_array(credit_card.errors)
          render json: { errors: errors }.to_json, status: 400
        end

      else
        render json: { errors: ["invalid user: #{params[:userId]}"] }.to_json, status: 400
      end
    end

    def update
    end

    def charge
    end

    private
      def get_user
        if User.exists?(params[:userId])
          user = User.find(params[:userId])
        end
      end

      def create_credit_card
        credit_card = CreditCard.new(cardNumber: params[:cardNumber],
                                    expirationDate: params[:expirationDate],
                                    cvc: params[:cvc]);
      end
  end
end
