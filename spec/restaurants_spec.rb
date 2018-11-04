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
      body = JSON.parse(response.body)
      expect(body["name"]).to eql("rest")
      expect(body["rating"]).to eql(0)
    end

  end

end