require 'rails_helper'

RSpec.describe "students/show", type: :view do
  before(:each) do
    assign(:student, Student.create!(
      inst_id: "Inst",
      person: nil,
      catalog_year: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Inst/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
