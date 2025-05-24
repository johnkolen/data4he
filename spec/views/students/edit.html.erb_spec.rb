require 'rails_helper'

RSpec.describe "students/edit", type: :view do
  include ControllerSetup
  classSetup object: :create_student,
             user: :admin_user

  it "renders the edit student form" do
    render
    assert_select "form[action=?][method=?]", student_path(object), "post" do
      assert_select "input[name=?]", "student[inst_id]"
    end
  end
end
