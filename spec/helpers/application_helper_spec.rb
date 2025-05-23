require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  it "tests if relation is one to one" do
    s = Student.new
    s.build_person
    helper.set_ov_obj s
    expect(helper.ov_one_to_one? :person).to be true
  end
end
