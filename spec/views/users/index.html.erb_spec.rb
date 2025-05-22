require 'rails_helper'
require_relative "../controller_setup"

RSpec.describe "users/index", type: :view do
  include ControllerSetup
  before(:all) do
    @u = create(:admin_user)
    @objects = [
      create(:student_user),
      create(:student_user_1)
    ]
  end
  after(:all) do
    @u.destroy
  end
  before(:each) do
    controllerSetup @u
    Access.user = @u
  end
  let(:user) { @u }
  before(:each) do
    assign(:objects, @objects)
    assign(:users, @objects)
  end

  it "renders a list of users" do
    render
    cell_selector = 'div>p'
  end
end
