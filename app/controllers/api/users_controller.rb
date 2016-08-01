module Api
  class UsersController < ApplicationController
    include ApplicationHelper

    skip_before_action :verify_authenticity_token

    def new
      #create user and credit card
      user = create_user()

      if user.valid?
        credit_card = create_credit_card(user, params)

        if credit_card.valid?
          user.save()
          credit_card.save()
          user.credit_cards.push(credit_card)
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
        render json: User.find(userId).to_json(except: [:password])
      else
        render json: { errors: ["user with id: #{userId} is not found"] }.to_json, status: 404
      end
    end

    def update
      userId = params[:userId]
    end

    private
      def create_user
        User.new(email: params[:email], password: params[:password],
                    firstName: params[:firstName], lastName: params[:lastName])
      end
  end
end
