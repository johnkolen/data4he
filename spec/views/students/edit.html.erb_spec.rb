require 'rails_helper'

RSpec.describe "students/edit", type: :view do
  let(:student) {
    Student.create!(
      inst_id: "MyString",
      person: nil,
      catalog_year: nil
    )
  }

  before(:each) do
    assign(:student, student)
  end

  it "renders the edit student form" do
    render

    assert_select "form[action=?][method=?]", student_path(student), "post" do

      assert_select "input[name=?]", "student[inst_id]"

      assert_select "input[name=?]", "student[person_id]"

      assert_select "input[name=?]", "student[catalog_year_id]"
    end
  end
end
