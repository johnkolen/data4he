require 'rails_helper'

RSpec.describe Student, type: :model do
  context "has dim catalog_year" do
    it "symbol" do
      expect(Student.is_dim? :catalog_year).to eq true
      expect(Student.is_dim? :catalog_year_id).to eq true
    end
    it "string" do
      expect(Student.is_dim? "catalog_year").to eq true
      expect(Student.is_dim? "catalog_year_id").to eq true
    end
  end
end
