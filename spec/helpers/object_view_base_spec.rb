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

  context "admin accesses text field in a" do
    helperSetup object: :create_student,
                user: :admin_user
    it "form" do
      attr = :inst_id
      elem = helper.ov_form object do |form|
        helper.ov_text_field(attr)
      end
      node = Nokogiri::HTML(elem)
      check node, :form, object, attr
    end

    it "display" do
      attr = :inst_id
      elem = helper.ov_display object do |form|
        helper.ov_text_field(attr)
      end
      node = Nokogiri::HTML(elem)
      check node, :display, object, attr
    end

    it "nested form" do
      attr = :last_name
      elem = helper.ov_form object do |form|
        helper.ov_fields_for :person do
          helper.ov_text_field(:last_name)
        end
      end
      node = Nokogiri::HTML(elem)
      #puts node.to_xhtml(indent: 2)
      check node, :form, object, :person_attributes, attr
    end

    it "display fields_for with one attribute" do
      attr = :last_name
      elem = helper.ov_display object do |form|
        helper.ov_fields_for :person do
          helper.ov_text_field(:last_name)
        end
      end
      node = Nokogiri::HTML(elem)
      #puts node.to_xhtml(indent: 2)
      check node, :display, object, :person_attributes, attr
    end

    it "form fields_for with one attribute" do
      attr = :last_name
      elem = helper.ov_form object do |form|
        helper.ov_fields_for :person do
          helper.ov_text_field(:last_name)
        end
      end
      node = Nokogiri::HTML(elem)
      #puts node.to_xhtml(indent: 2)
      check node, :form, object, :person_attributes, attr
    end

    it "form fields_for with all attributes" do
      attr = :last_name
      elem = helper.ov_form object do |form|
        helper.ov_fields_for :person
      end
      node = Nokogiri::HTML(elem)
      #puts node.to_xhtml(indent: 2)
      check node, :form, object, :person_attributes, attr
    end
  end

  context "student self accesses text field in a" do
    helperSetup object: :create_student,
                user: :student_user
    before :each do
      @hold_user = Access.user
      Access.user = create(:user, person: object.person)
    end
    after :each do
      Access.user.destroy
      Access.user = @hold_user
    end
    it "student form" do
      elem = helper.ov_form object do
        #expect(ov_allow? helper.ov_form.object, :edit).to be true
        helper.ov_fields_for :person do
          expect(ov_allow? :last_name, :edit).to be true
          expect(ov_allow? :ssn, :edit).to be true
        end
        helper.ov_fields_for :person
      end
      #node = Nokogiri::HTML(elem)
      #puts node.to_xhtml(indent: 2)
    end
  end
  context "ov_allow" do
    it "form attribute with no edit or view" do
      access = Class.new AccessBase do
        define_access :view
        define_access :edit
        allow [:view, :edit], Student, :admin do
          deny :edit, :inst_id, :admin
        end
      end
      access.user = Access.user

      helper.ov_with_access_class access do
        r = helper.ov_allow? object, :edit do
          expect(helper.ov_allow? :inst_id, :edit).to be false
          expect(helper.ov_allow? :inst_id, :view).to be false
        end
        expect(r).to be true
      end
    end

    it "form attribute with no edit but view" do
      access = Class.new AccessBase do
        define_access :view
        define_access :edit
        allow [:view, :edit], Student, :admin do
          deny :edit, :inst_id, :admin
          allow :view, :inst_id, :admin
        end
      end
      access.user = Access.user

      helper.ov_with_access_class access do
        expect(helper.ov_access_class).to be access
        r = helper.ov_allow? object, :edit do
          expect(helper.ov_allow? :inst_id, :edit).to be false
          expect(helper.ov_allow? :inst_id, :view).to be true
        end
        expect(r).to be true
      end
    end
  end

  DELTA = {form: 0, display: 1}
  def check node, kind, obj, *rest
    head = obj.class.to_s.underscore
    attr = rest.last
    d = DELTA[kind]
    tail = rest.map{|x| "[#{x}]" }.join
    path = "#{head}#{tail}"
    assert_dom node, "div[class=\"ov-display\"]", d
    assert_dom node, "form[class=\"ov-form\"]", 1 - d do
      assert_dom node, "label[for=?]", rest.last
      assert_dom node, "input[name=?]", path, 1 - d
      assert_dom node, "div[class=\"ov-text\"]", d
    end
  end
end
