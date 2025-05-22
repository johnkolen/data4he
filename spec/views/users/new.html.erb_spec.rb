require 'rails_helper'
require_relative "../controller_setup"

RSpec.describe "users/new", type: :view do
  include ControllerSetup
  classSetup object: :build_student_user,
             user: :admin_user

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do
    end
  end
end
