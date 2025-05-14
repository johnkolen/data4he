require 'rails_helper'

RSpec.describe "People", type: :request do
  #describe "GET /index" do
  #  pending "add some examples (or delete) #{__FILE__}"
  #end
  describe "POST /create" do
    it 'unnested attributes' do
      params = {
        #"authenticity_token"=>"[FILTERED]",
        "person"=>{"first_name"=>"aa",
                   "last_name"=>"PostUA",
                   "date_of_birth"=>"2025-05-02",
                   "ssn"=>"920-82-1111",
                   "age"=>"33"
                  }
      }
      expect {
        post people_path, params: params
      }.to change{Person.count}.by(1)

      expect(response).to redirect_to(assigns(:person))

      p = Person.where(last_name: params["person"]["last_name"]).first
      expect(p.phone_numbers.size).to eq 0
    end
    it 'nested attributes' do
      params = {
        "person"=>{"first_name"=>"aa",
                   "last_name"=>"PostNA",
                   "date_of_birth"=>"2025-05-02",
                   "ssn"=>"920-82-1111",
                   "age"=>"33",
                   "phone_numbers_attributes"=>{
                     "0"=>{"number"=>"(850)603-9985",
                           "primary"=>"1",
                           "active"=>"0"}}}}
      #pn = PhoneNumber.new(params["person"]["phone_numbers_attributes"]["0"])
      #puts pn.errors.inspect
      #expect(pn.valid?).to eq true

      expect {
        post "/people", params: params
      }.to change{Person.count}.by(1)
      expect(response).to redirect_to(assigns(:person))
      p = Person.where(last_name: params["person"]["last_name"]).first
      expect(p.phone_numbers.size).to eq 1
    end
  end
end
