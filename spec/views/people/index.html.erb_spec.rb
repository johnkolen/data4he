require 'rails_helper'

RSpec.describe "people/index", type: :view do
  before(:each) do
    assign(:people, [
      Person.create!(
        first_name: "First Name",
        last_name: "Last Name",
        ssn: "Ssn"
      ),
      Person.create!(
        first_name: "First Name",
        last_name: "Last Name",
        ssn: "Ssn"
      )
    ])
  end

  it "renders a list of people" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("First Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Last Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Ssn".to_s), count: 2
  end
end
