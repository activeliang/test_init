require 'rails_helper'

RSpec.describe Parking, type: :model do


      context "guest" do
         # (略，本来的一般费率测试放在这层)
         it "is invalid without amount" do
           parking = Parking.new( :parking_type => "guest",
                                  :start_at => Time.now - 6.hours,
                                  :end_at => Time.now)
           expect( parking ).to_not be_valid
         end

         it "is invalid without end_at" do
           parking = Parking.new( :parking_type => "guest",
                                  :start_at => Time.now - 6.hours,
                                  :amount => 999)
           expect( parking ).to_not be_valid
         end
      end

      context "short-term" do
        it "30 mins should be ¥2" do
          t = Time.now
          parking = Parking.new( :parking_type => "short-term",
                                 :start_at => t, :end_at => t + 30.minutes )
          parking.user = User.create(:email => "test@example.com", :password => "123455678")

          parking.calculate_amount
          expect(parking.amount).to eq(200)
        end

        it "60 mins should be ¥2" do
          t = Time.now
          parking = Parking.new( :parking_type => "short-term",
                                 :start_at => t, :end_at => t + 60.minutes )
          parking.user = User.create(:email => "test@example.com", :password => "123455678")

          parking.calculate_amount
          expect( parking.amount ).to eq(200)
        end

        it "61 mins should be ¥2.5" do
          t = Time.now
          parking = Parking.new( :parking_type => "short-term",
                                 :start_at => t, :end_at => t + 61.minutes )
          parking.user = User.create(:email => "test@example.com", :password => "123455678")

          parking.calculate_amount

          expect( parking.amount ).to eq(250)
        end

        it "90 mins should be ¥2.5" do
          t = Time.now
          parking = Parking.new( :parking_type => "short-term",
                                 :start_at => t, :end_at => t + 90.minutes )
          parking.user = User.create(:email => "test@example.com", :password => "123455678")

          parking.calculate_amount
          expect( parking.amount ).to eq(250)
        end

        it "120 mins should be ¥3" do
          t = Time.now
          parking = Parking.new( :parking_type => "short-term",
                                 :start_at => t, :end_at => t + 120.minutes )
          parking.user = User.create(:email => "test@example.com", :password => "123455678")

          parking.calculate_amount
          expect( parking.amount ).to eq(300)
        end

      end
end
