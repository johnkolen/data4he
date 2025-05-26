require 'rails_helper'

RSpec.describe AcademicYear, type: :model do
  it "initializes" do
    ay = AcademicYear.new
    expect(ay).to be_a AcademicYear
  end
end
