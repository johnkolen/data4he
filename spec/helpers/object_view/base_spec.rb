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
  context "helpers" do
    it "ov_obj_class_name_u" do
      helper.set_ov_obj build(:story_task)
      expect(helper.ov_obj_class_name_u).to eq "story_task"
    end
    it "ov_obj_class_name_k" do
      helper.set_ov_obj build(:story_task)
      expect(helper.ov_obj_class_name_k).to eq "story-task"
    end
  end
  context "access" do
    helperSetup user: :admin_user
    it "ov_render" do
      elem = helper.ov_render "people/person", {person: build(:person)}
      puts elem
    end
  end
end
