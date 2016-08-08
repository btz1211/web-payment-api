module Api
  class UsersController < ApplicationController
    include ApplicationHelper
    include CreditCardsHelper

    skip_before_action :verify_authenticity_token

    PRICE_HASH = {1 => 5999, 2 => 7999}

    def new
      puts "params::#{params}"

      #create user and credit card
      user = create_user()

      if user.valid?
        credit_card = create_credit_card(params[:creditCard])

        if credit_card.valid?
          user.save()
          credit_card.save()
          user.credit_cards.push(credit_card)

          #set user cookie
          set_user_cookie(user)

          #return created json
          render json: user.as_json(except: [:password])
        else
          errors = convert_error_hash_to_array(credit_card.errors)
          render json: { errors: errors }.to_json, status: 400
        end

      else
        errors = convert_error_hash_to_array(user.errors)
        render json: { errors: errors }.to_json, status: 400
      end

    end

    def index
      render json: User.all.to_json(except: [:password])
    end

    def show
      userId = params[:userId]

      if User.exists?(id: userId)
        user = User.find(userId)
        render json: user.to_json(except: [:password], include: :credit_cards)
      else
        render json: { errors: ["user with id: #{userId} is not found"] }.to_json, status: 404
      end
    end

    def authenticate
      email = params[:email]
      password = params[:password]

      if User.where(email: email, password: password).present?
        user = User.where(email: email, password: password).first
        set_user_cookie(user)
        render json: user.to_json
      else
        render json:{ errors: ["invalid credentials"] }.to_json, status: 401
      end
    end

    def update
      userId = params[:userId]
    end

    def order
      userId = params[:userId]

      if User.exists?(id: userId)
        user = User.find(userId)
        credit_card = user.credit_cards.first

        begin
          charge_card(credit_card,  PRICE_HASH[user.planId] , "Order for #{Time.now}")
          render json: { success: true }
        rescue Exception => e
          render json: {errors: ["unable to charge due to: #{e}"] }.to_json, status: 500
        end
      else
        render json: { errors: ["user with id: #{userId} is not found"] }.to_json, status: 404
      end

    end

    private
      def create_user
        User.new(email: params[:email], password: params[:password],
                    firstName: params[:firstName], lastName: params[:lastName],
                    planId: params[:planId])
      end
      def set_user_cookie(user)
        cookies[:user] = { value: user.to_json(except: [:password]), expires: 30.minute.from_now }
      end
  end
end
