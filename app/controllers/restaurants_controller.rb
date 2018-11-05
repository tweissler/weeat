require_relative './application_controller'
require 'active_record'

class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]
  #TODO: consider adding authentication
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_id_handler

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
    @restaurant = Restaurant.create(restaurant_params)
    render :json => @restaurant.valid? ? @restaurant : {status: "error", code: 400, message: @restaurant.errors.full_messages}
  end

  #PATCH /restaurants:/:id
  def update
    @restaurant.update(restaurant_params)
    #TODO: could there be other errors other than 400 (failed model validations) from this object?
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

  def invalid_id_handler
    #TODO: this is the response in order not to give information regarding existing id's. is this a good decision?
    head :no_content
  end

end
