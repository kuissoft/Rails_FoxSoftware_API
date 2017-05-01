require 'rails_helper'

describe Api::V1::ShipmentsController do

  before do
    @user = create :user
    @shipment = create :shipment, user: @user
  end

  context 'unauthorized browsing' do
    it 'should not let visitors read shipment(s)' do
      json_query :get, :show, id: @shipment.id
      expect(@json[:errors].size).to eq 1
    end
  end

  context 'Carrier browsing shipments' do
    login_user


    before do
      @logged_in_user.add_role :carrier
    end

    it 'should let authorized carrier to read invited shipment' do
      # TODO Check with Matt, if way by invited shipment or ANY shipment upon inv'
    end

    it 'should not let carrier see inactive shipments' do
      # TODO same as others
    end

    it "should not let carrier read someone's shipment" do
      ## TODO check with Matt about permitting carriers to look on any shipment/shipment
    end

  end

  context 'Client shipments manipulations' do

    login_user

    before do
      @logged_in_user.add_role :client
    end

    context 'listing' do
      it 'should let client list its shipments' do
        create_list :shipment, 2, user: @logged_in_user
        json_query :get, :index
        expect(@json[:results].size).to eq 2
        expect(@json[:results].first['active']).to eq true
      end

      it 'should not let client list other shipments' do
        create_list :shipment, 2
        json_query :get, :index
        expect(@json[:results].size).to eq 0
      end
    end

    context 'saving' do
      before do
        @attrs = {dim_w: 10, dim_h: 20.22, dim_l: 30.3, distance: 50, notes: 'TEST DS', price: 1005.22, pickup_at: 2.days.from_now.to_s, arrive_at: 3.days.from_now.to_s}
      end

      it 'should let client create new shipment' do
        expect {
          json_query :post, :create, shipment: @attrs
          expect(@json[:status]).to eq 'ok'
        }.to change{Shipment.count}
      end

      it 'should not let client create invalid shipment' do
        @attrs[:price] = nil
        expect {
          json_query :post, :create, shipment: @attrs
          expect(@json[:error]).not_to be blank?
          expect(@json[:text][0]).to eq "Price can't be blank"
        }.not_to change{Shipment.count}
      end

      context 'editing' do
        before do
          @shipment = create :shipment, user: @logged_in_user
        end

        it 'should let client edit its own shipment' do
          expect {
            json_query :put, :update, id: @shipment.id, shipment: {price: 22.32}
            expect(@json[:status]).to eq 'ok'
            @shipment.reload
          }.to change(@shipment, :price)
        end

        it 'should not let client save bad details' do

        end

        it "should not let client edit someone's shipment" do

        end

        it 'should delete shipment' do

        end

        it 'should make inactive shipment' do

        end

      end
    end

  end

end