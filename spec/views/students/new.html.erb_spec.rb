require 'rails_helper'

RSpec.describe "students/new", type: :view do
  before(:each) do
    assign(:student, Student.new(
      inst_id: "MyString",
      person: nil,
      catalog_year: nil
    ))
  end

  it "renders new student form" do
    render

    assert_select "form[action=?][method=?]", students_path, "post" do

      assert_select "input[name=?]", "student[inst_id]"

      assert_select "input[name=?]", "student[person_id]"

      assert_select "input[name=?]", "student[catalog_year_id]"
    end
  end
end
