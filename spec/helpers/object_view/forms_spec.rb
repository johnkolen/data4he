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

  it "calls formish" do
    helper.ov_formish
  end

  context "total accsss form" do
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
        #puts helper.ov_access_class.tree_str
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
        #puts helper.ov_access_class.tree_str
        h_ov_check :form,
                   object, :person_attributes, :last_name do
          helper.ov_form object do |form|
            helper.ov_fields_for :person
          end
        end
      end
    end

  end

  context "total accsss except attribute form" do
    helperSetup object: :create_student,
                user: :admin_user do
      define_access :view
      define_access :edit
      # label resource role
      allow [:view, :edit], Student, :admin do
        allow [:view, :edit], Person, :admin do
          deny :edit, :ssn, :admin
        end
      end
    end

    it "nested with one attribute" do
      with_access do
        #puts helper.ov_access_class.tree_str
        h_ov_check :form, object, :person_attributes, attr = :ssn,
                   no_input: [ :ssn ],
                   no_label: [ :ssn ] do
          helper.ov_form object do |form|
            helper.ov_fields_for :person do
              helper.ov_text_field(attr)
            end
          end
        end
      end
    end

    it "nested with all attributes" do
      with_access do
        #puts helper.ov_access_class.tree_str
        h_ov_check :form,
                   object, :person_attributes, :ssn,
                   no_input: [ :ssn ],
                   no_label: [ :ssn ] do
          helper.ov_form object do |form|
            helper.ov_fields_for :person
          end
        end
      end
    end

  end

  context "total accsss only view attribute form" do
    helperSetup object: :create_student,
                user: :admin_user do
      define_access :view
      define_access :edit
      # label resource role
      allow [:view, :edit], Student, :admin do
        allow [:view, :edit], Person, :admin do
          deny :edit, :ssn, :admin
          allow :view, :ssn, :admin
        end
      end
    end

    it "nested with one attribute" do
      with_access do
        #puts helper.ov_access_class.tree_str
        h_ov_check :form, object, :person_attributes, attr = :ssn,
                   no_input: [ :ssn ],
                   display: [ :ssn ] do
          helper.ov_form object do |form|
            helper.ov_fields_for :person do
              helper.ov_text_field(attr)
            end
          end
        end
      end
    end

    it "nested with all attributes" do
      with_access do
        #puts helper.ov_access_class.tree_str
        h_ov_check :form,
                   object, :person_attributes, :ssn,
                   no_input: [ :ssn ],
                   display: [ :ssn ] do
          helper.ov_form object do |form|
            helper.ov_fields_for :person
          end
        end
      end
    end
  end

  context "self accsss only view attribute form" do
    helperSetup object: :create_student,
                user: :admin_user do
      define_access :view
      define_access :edit
      # label resource role
      allow [:view, :edit], Student, :self do
        deny :edit, :inst_id, :self
        allow :view, :inst_id, :self
        allow [:view, :edit], Person, :self do
          deny :edit, :ssn, :self
          allow :view, :ssn, :self
        end
      end
    end

    before :each do
      u = create(:user, role_id: User::RoleStudent, person: s_object.person)
      Access.user = u
      puts "before: #{u.inspect}"
      destroy_list << u
    end

    it "containing a single attribute" do
      puts self.class.access_class.tree_str
      with_access do
        h_ov_check :form, object, attr = :inst_id, pp: true,
                   no_input: [attr],
                   display: [attr] do
          helper.ov_form object, allow:{why: true} do |form|
            puts "@" * 70
            puts "#{ov_access_class.object_id.inspect}"
            puts self.class.access_class.node.inspect
            expect(ov_allow? attr, :edit).not_to be true
            puts self.class.access_class.node.inspect
            expect(ov_allow? attr, :view, why: true).to be true
            puts self.class.access_class.node.inspect
            helper.ov_text_field(attr)
          end
        end
      end
    end

    it "nested with one attribute" do
      with_access do
        #puts helper.ov_access_class.tree_str
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
        #puts helper.ov_access_class.tree_str
        h_ov_check :form,
                   object, :person_attributes, :last_name do
          helper.ov_form object do |form|
            helper.ov_fields_for :person
          end
        end
      end
    end
  end
end
