require 'rails_helper'

RSpec.describe "people/edit", type: :view do
  let(:person) {
    Person.create!(
      first_name: "MyString",
      last_name: "MyString",
      ssn: "MyString"
    )
  }

  before(:each) do
    assign(:person, person)
  end

  it "renders the edit person form" do
    render

    assert_select "form[action=?][method=?]", person_path(person), "post" do

      assert_select "input[name=?]", "person[first_name]"

      assert_select "input[name=?]", "person[last_name]"

      assert_select "input[name=?]", "person[ssn]"
    end
  end
end
