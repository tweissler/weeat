require 'rails_helper'
require 'json'
require_relative '../../app/controllers/restaurants_controller'
require 'database_cleaner'

RSpec.describe RestaurantsController, type: :controller do

  DatabaseCleaner.strategy = :truncation

  describe "#show" do
    let(:rest) { FactoryBot.create(:italian_with_tenbis) }
    it "retrieve restaurant successfully" do
      get :show, params: { id: rest.id }
      expect(response.status).to eq 200
    end

    it "retrieve the correct restaurant" do
      get :show, params: { id: rest.id }
      body = JSON.parse(response.body)
      expect(body["name"]).to be_present
      expect(body["cuisine"]).to eql("italian")
      expect(body["tenbis"]).to be true
    end

    it "retrieve non existing restaurant" do
      get :show, params: { id: 12345 }
      expect(response.status).to eq 404
    end
  end

  describe "#index" do
    let!(:rest) { FactoryBot.create_list(:restaurant, 4) }
    it "list restaurants" do
      get :index
      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      expect(body.length).to eq 4
    end

    it "list restaurants with filter" do
      get :index, params: { by_cuisine: "a" }
      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      expect(body.length).to eq 0
    end
  end

  describe "#create" do
    it "create restaurant successfully" do
      post :create, params: { name: "rest" }
      expect(response.status).to eq 201
      expect(Restaurant.count).to eq 1
    end

    it "create restaurant correctly" do
      post :create, params: { name: "rest" }
      rest = Restaurant.last
      expect(rest["name"]).to eql("rest")
      expect(rest["tenbis"]).to eql(false)
      expect(rest["delivery_time"]).to eql(0)
    end

    it "create restaurant with wrong parameters" do
      post :create, params: { delivery_time: -1 }
      expect(response.status).to eq 400
    end
  end

  describe "#update" do
    let!(:rest) { FactoryBot.create(:restaurant) }
    it "update restaurant successfully" do
      patch :update, params: { id: rest.id, delivery_time: 30 }
      expect(response.status).to eq 200
    end

    it "update restaurant correctly" do
      patch :update, params: { id: rest.id, delivery_time: 30 }
      body = JSON.parse(response.body)
      expect(body["delivery_time"]).to eql(30)
    end
  end

  describe "#destroy" do
    let!(:rest) { FactoryBot.create(:restaurant) }
    it "delete restaurant" do
      delete :destroy, params: { id: rest.id }
      expect(response.status).to eq 204
      expect(Restaurant.last).to be_nil
    end
  end

  describe "#load", :vcr do
    it "delete restaurant" do
      get :load
      expect(response.status).to eq 200
    end
  end

end