require 'rails_helper'

RSpec.describe "users/edit_profile", type: :view do
  include ControllerSetup
  classSetup object: :create_student_user,
             user: :admin_user

  views_models_edit form: "form_profile"

  it "renders attributes with user" do
    hold = Access.user
    Access.user = object
    views_models_edit form: "form_profile"
  ensure
    Access.user = hold
  end
end
