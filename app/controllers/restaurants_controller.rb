class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]

  # GET /restaurants
  def index
    @restaurant = Restaurant.all
  end

  # GET /restaurants/1
  def show

  end

  #POST /restaurants
  def create
    @restaurant = Restaurant.new(restaurant_params)
  end

  #PATCH/PUT /restaurants/1
  def update
    @restaurant.update(restaurant_params)
  end

  #DELETE /restaurants/1
  def destroy
    @restaurant.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :cuisine, :rating, :tenbis, :address, :delivery_time)
    end
end
