require 'rails_helper'
require 'json'
require_relative '../app/controllers/restaurants_controller'
require_relative './restaurants'
#TODO: should the reqiures be here or in spec_helper?

RSpec.describe RestaurantsController, type: :controller do

  describe "#show" do
    let!(:rest) { create(:restaurant) }
    it "retrieve restaurant" do
      get :show, params: { id: rest.id }
      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      expect(body["name"]).to be_present
      expect(body["rating"]).to eql(0)
    end
  end

  describe "#index" do
    let!(:rest) { create_list(:restaurant, 4) }
    it "list restaurants" do
      get :index
      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      expect(body.length).to eq 4
    end
  end

  describe "#create" do
    it "create restaurant" do
      post :create, params: { name: "rest" }
      expect(response.status).to eq 201
      rest = Restaurant.last
      expect(rest["name"]).to eql("rest")
      expect(rest["rating"]).to eql(0)
      expect(rest["tenbis"]).to eql(false)
      expect(rest["delivery_time"]).to eql(0)
    end
  end

  describe "#update" do
    let!(:rest) { create(:restaurant) }
    it "update restaurant" do
      patch :update, params: { id: rest.id, rating: 3 }
      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      expect(body["rating"]).to eql(3)
    end
  end

  describe "#destroy" do
    let!(:rest) { create(:restaurant) }
    it "delete restaurant" do
      delete :destroy, params: { id: rest.id }
      expect(response.status).to eq 204
      expect(Restaurant.last).to be_nil
    end
  end


  describe "#show" do
    let!(:rest) { create(:restaurant) }
    it "retrieve non existing restaurant" do
      get :show, params: { id: 123 }
      expect(response.status).to eq 204
    end
  end

  describe "#create" do
    it "create restaurant with wrong parameters" do
      post :create, params: { rating: 5, delivery_time: -1 }
      expect(response.status).to eq 400
    end
  end

end