require 'rails_helper'

RSpec.describe "people/show", type: :view do
  before(:each) do
    assign(:person, Person.create!(
      first_name: "First Name",
      last_name: "Last Name",
      ssn: "Ssn"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Ssn/)
  end
end
