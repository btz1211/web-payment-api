module Api
  class CreditCardsController < ApplicationController
    include ApplicationHelper

    before_action  :get_user

    def index
      if @user
        render json: @user.credit_cards.to_json(except: [:cvc])
      else
        render json: { errors: ["invalid user: #{params[:userId]}"] }.to_json, status: 400
      end
    end

    def show
      if @user
        render json: get_credit_card.to_json(except: [:cvc])
      else
        render json: { errors: ["invalid user: #{params[:userId]}"] }.to_json, status: 400
      end
    end

    def new
      if @user
        credit_card = create_credit_card(@user, params);

        if credit_card.valid?
          #save credit card data
          credit_card.save()
          @user.credit_cards.push(credit_card)

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
      if @user
        credit_card =  get_credit_card()

        if credit_card
          #call stripe api to charge card
          begin
            amount = params[:amount].to_i

            if amount >= 50
              charge = Stripe::Charge.create(
                :amount => amount,
                :currency => "usd",
                :customer => credit_card[:stripe_token],
                :description => params[:charge_description]
              )

              render json:{ result: "success" }.to_json
            else
              render json: {errors: ["invalid charge amount: #{params[:amount]}, please provide amount in cents (i.e 100 is a $1), and at least 50 cents"] }.to_json, status: 500
            end
          rescue Stripe::CardError => e
            render json: {errors: ["unable to charge due to: #{e}"] }.to_json, status: 500
          end
        else
          render json: { errors: ["invalid credit card: #{params[:credit_card_id]}"] }.to_json, status: 400
        end
      else
        render json: { errors: ["invalid user: #{params[:userId]}"] }.to_json, status: 400
      end
    end

    private
      def get_user
        if User.exists?(params[:userId])
          @user = User.find(params[:userId])
        end
      end

      def get_credit_card
        @user.credit_cards.find(params[:credit_card_id])
      end
  end
end
