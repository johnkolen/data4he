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

RSpec.describe ObjectViewBase, type: :helper do
  context "text field" do
    helperSetup object: :create_student,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      elem = helper.ov_form object do |form|
        helper.ov_text_field(:inst_id)
      end
      node = Nokogiri::HTML(elem)
      assert_dom node, "div[class=\"ov-display\"]", 0
      assert_dom node, "form[class=\"ov-form\"]" do
        assert_dom node, "label[for=\"inst_id\"]"
        assert_dom node, "input[name=\"student[inst_id]\"]"
        assert_dom node, "div[class=\"ov-text\"]", 0
      end
    end
    it "display" do
      elem = helper.ov_display object do |form|
        helper.ov_text_field(:inst_id)
      end
      node = Nokogiri::HTML(elem)
      assert_dom node, "form[class=\"ov-form\"]", 0
      assert_dom node, "div[class=\"ov-display\"]" do
        assert_dom node, "label[for=\"inst_id\"]"
        assert_dom node, "input[name=\"student[inst_id]\"]", 0
        assert_dom node, "div[class=\"ov-text\"]"
      end
    end
  end

end
