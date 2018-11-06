require_relative './application_controller'
require 'active_record'

class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]
  #TODO: consider adding authentication
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_id_handler

  # GET /restaurants
  def index
    @restaurants = Restaurant.all
    @restaurants = @restaurants.where('cuisine = ?', query_params["by_cuisine"]) if query_params.has_key? "by_cuisine"
    @restaurants = @restaurants.where('rating >= ?', query_params["min_rating"].to_i) if query_params.has_key? "min_rating"
    @restaurants = @restaurants.where('delivery_time <= ?', query_params["max_delivery_time"].to_i) if query_params.has_key? "max_delivery_time"
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
    #TODO: could there be other errors other than bad request (failed model validations) from this object?
    @restaurant.valid? ? (render :json => @restaurant, :status => :created) : (render :json => @restaurant.errors.full_messages, :status => :bad_request)
  end

  #PATCH /restaurants:/:id
  def update
    @restaurant.update(restaurant_params)
    @restaurant.valid? ? (render :json => @restaurant) : (render :json => @restaurant.errors.full_messages, :status => :bad_request)
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

  def query_params
    request.query_parameters.slice(:by_cuisine, :min_rating, :max_delivery_time)
  end

  def invalid_id_handler
    #TODO: this is the response in order not to give information regarding existing id's. is this a good decision?
    head :no_content
  end

end
