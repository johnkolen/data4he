require 'rails_helper'

RSpec.describe "students/new", type: :view do
  include ControllerSetup
  classSetup object: :build_student,
             user: :admin_user

  it "renders new student form" do
    render
    assert_select "form[action=?][method=?]", students_path, "post" do
      assert_select "input[name=?]", "student[inst_id]"
    end
  end
end
