require 'active_record/errors'

class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found_handler

  # GET /restaurants
  def index
    @restaurants = Restaurant.all
    render :json => @restaurants
  end

  # GET /restaurants/:id
  def show
    @restaurant
    render :json => @restaurant
  end

  #POST /restaurants
  def create
    @restaurant = Restaurant.new(restaurant_params)
    render :json => @restaurant.valid? ? @restaurant : {status: "error", code: 400, message: @restaurant.errors.full_messages}
  end

  #PATCH /restaurants:/id
  def update
    @restaurant.update(restaurant_params)
    #could there be other errors other than 400 (failed model validations) from this object?
    render :json => @restaurant.valid? ? @restaurant : {status: "Bad Request", code: 400, message: @restaurant.errors.full_messages}
  end

  #DELETE /restaurants/:id
  def destroy
    @restaurant.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_params
    params.permit(:id, :name, :cuisine, :rating, :tenbis, :address, :delivery_time)
  end

  def record_not_found_handler
    #this gives the attacker information regarding existing id's, consider another response
    render :json => {:status => "Bad Request", :code => 400}
  end

end
