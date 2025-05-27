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
  context "form" do
    helperSetup object: :create_student,
                user: :admin_user do
      define_access :view
      define_access :edit
      # label resource role
      allow [:view, :edit], Student, :admin do
        allow [:view, :edit], Person, :admin
      end
    end

    it "containing a single attribute" do
      with_access do
        h_ov_check :form, object, attr = :inst_id do
          helper.ov_form object do |form|
            helper.ov_text_field(attr)
          end
        end
      end
    end

    it "nested with one attribute" do
      with_access do
        puts helper.ov_access_class.tree_str
        h_ov_check :form, object, :person_attributes, attr = :last_name do
          helper.ov_form object do |form|
            helper.ov_fields_for :person do
              helper.ov_text_field(:last_name)
            end
          end
        end
      end
    end

    it "nested with all attributes" do
      with_access do
        h_ov_check :form,
                   object, :person_attributes, :last_name,
                   pp: true do
          helper.ov_form object do |form|
            helper.ov_fields_for :person
          end
        end
      end
    end

  end

end
