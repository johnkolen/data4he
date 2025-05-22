require 'rails_helper'
require_relative "../controller_setup"

RSpec.describe "users/show", type: :view do
  include ControllerSetup
  classSetup object: :create_student_user,
             user: :admin_user

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{object.email}/)
  end
end
