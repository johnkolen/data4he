require 'rails_helper'
require_relative "../controller_setup"

RSpec.describe "users/index", type: :view do
  include ControllerSetup
  classSetup object: [
               :create_student_user,
               :create_student_user_1
             ],
             user: :admin_user

  it "renders a list of users" do
    render

    cell_selector = 'div>p'
    objects.each do |obj|
      expect(rendered).to match(/#{obj.email}/)
    end
  end
end
