require 'rails_helper'

RSpec.describe "students/show", type: :view do
  include ControllerSetup
  classSetup object: :create_student,
             user: :admin_user

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{object.inst_id}/)
  end
end
