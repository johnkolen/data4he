require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  include ControllerSetup
  classSetup object: :create_student_user,
             user: :admin_user

  it "renders attributes in <p>" do
    render
    assert_select "form[action=?][method=?]", user_path(object), "post" do
    end
  end
end
