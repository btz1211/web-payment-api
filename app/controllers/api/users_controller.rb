module Api
  class UsersController < ApplicationController
    include ApplicationHelper

    skip_before_action :verify_authenticity_token
    before_action :create_user, :only => [:new]

    def new
      if @user.valid?
        @user.save()
        render json: @user.as_json(except: [:id, :password])
      else
        errors = convert_error_hash_to_array(@user.errors)
        render json: { errors: errors }.to_json, status: 400
      end
    end

    def index
      render json: User.all.to_json
    end

    def show
      userId = params[:userId]

      if User.exists?(id: userId)
        render json: User.find(userId).to_json
      else
        render json: { errors: ["user with id: #{userId} is not found"] }.to_json, status: 404
      end
    end

    def update
      userId = params[:userId]

    end

    def charge
      render json: 'charge'
    end

    private
      def create_user
        @user = User.new(email: params[:email], password: params[:password],
                    firstName: params[:firstName], lastName: params[:lastName])
      end
  end
end
