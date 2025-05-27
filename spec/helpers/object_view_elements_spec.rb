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

RSpec.describe ObjectViewElements, type: :helper do

  def fake_form &block
    helper.form_with model: object do |form|
      helper.set_ov_form form
      r = helper.ov_allow? object, :edit do
        yield
      end
      expect(r).to be(true), "can't access object"
    end
  end

  def fake_display &block
    helper.set_ov_form nil
    r = helper.ov_allow? object, :view do
      yield
    end
    expect(r).to be(true), "can't access object"
  end

  def assert_input elem, obj, attr, **options, &block
    expect(elem).not_to be_nil, "elem not generated"
    klass = obj.class_name_u
    node = Nokogiri::HTML(elem)
    assert_dom node, "label[for=?]", attr
    assert_dom node, "input[name=?]", "#{klass}[#{attr}]"
    assert_dom node,
               "div[class=?]",
               options[:div_class] || "ov-text",
               0
    if block_given?
      yield node, klass
    end
  end

  def assert_textarea elem, obj, attr, **options, &block
    expect(elem).not_to be_nil, "elem not generated"
    klass = obj.class_name_u
    node = Nokogiri::HTML(elem)
    assert_dom node, "label[for=?]", attr
    assert_dom node, "textarea[name=?]", "#{klass}[#{attr}]"
    assert_dom node,
               "div[class=?]",
               options[:div_class] || "ov-text-area",
               0
    if block_given?
      yield node, klass
    end
  end

  def assert_display elem, obj, attr, **options, &block
    expect(elem).not_to be_nil, "elem not generated"
    klass = obj.class_name_u
    node = Nokogiri::HTML(elem)
    assert_dom node, "label[for=?]", attr
    assert_dom node, "input[name=?]", "#{klass}[#{attr}]", 0
    assert_dom node, "textarea[name=?]", "#{klass}[#{attr}]", 0
    assert_dom node,
               "div[class=?]",
               options[:div_class] || "ov-text",
               1
    if block_given?
      yield node, klass
    end
  end

  context "text field" do
    helperSetup object: :create_student,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      fake_form do
        elem = helper.ov_text_field(:inst_id)
        assert_input elem, object, :inst_id
      end
    end

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
        fake_form do
          elem = helper.ov_text_field(:inst_id)
          expect(elem).to be_nil, "elem generated unexpectedly"
        end
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
        fake_form do
          elem = helper.ov_text_field(:inst_id)
          assert_display elem, object, :inst_id
        end
      end
    end

    it "text" do
      fake_display do
        elem = helper.ov_text_field(:inst_id)
        assert_display elem, object, :inst_id
      end
    end
  end

  context "text area" do
    helperSetup object: :create_student,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      fake_form do
        elem = helper.ov_text_area(:inst_id)
        assert_textarea elem, object, :inst_id, div_class: 'ov-textarea'
      end
    end
    it "text" do
      fake_display do
        elem = helper.ov_text_area(:inst_id)
        assert_display elem, object, :inst_id, div_class: 'ov-textarea'
      end
    end
  end

  context "password field" do
    helperSetup object: :create_user,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      fake_form do
        elem = helper.ov_password_field(:password)
        assert_input elem, object, :password, div_class: 'ov-password'
      end
    end
    it "text" do
      fake_display do
        elem = helper.ov_password_field(:password)
        assert_display elem, object, :password, div_class: 'ov-password'
      end
    end
  end

  context "checkbox" do
    helperSetup object: :create_phone_number,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      # phone_number_path isn't defined as there is not phone_number
      # controller
      pnp = helper.class.respond_to? :phone_number_path
      unless pnp
        helper.class.define_method :phone_number_path do |obj, *arg, **other|
          ""
        end
      end
      fake_form do
        elem = helper.ov_checkbox(:active)
        node = Nokogiri::HTML(elem)
        assert_dom node, "label[for=\"active\"]"
        assert_dom node, "input[name=\"phone_number[active]\"][type=\"checkbox\"]"
        assert_dom node, "input[onclick=\"return false\"]", 0
      end
    ensure
      unless pnp
        helper.class.undef_method :phone_number_path
      end
    end
    it "text" do
      fake_display do
        elem = helper.ov_checkbox(:active)
        node = Nokogiri::HTML(elem)
        assert_dom node, "label[for=\"active\"]"
        assert_dom node, "input[name=\"phone_number[active]\"]", 0
        assert_dom node, "input[onclick=\"return false\"]"
      end
    end
  end

  context "select" do
    helperSetup object: :create_user,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      helper.form_with model: object do |form|
        helper.set_ov_form form
        elem = helper.ov_select(:role)
        node = Nokogiri::HTML(elem)
        assert_dom node, "label[for=\"role\"]"
        assert_dom node, "select[name=\"user[role_id]\"]"
        assert_dom node, "div[class=\"ov-text\"]", 0
      end
    end
    it "text" do
      helper.set_ov_form nil
      elem = helper.ov_select(:role)
      node = Nokogiri::HTML(elem)
      assert_dom node, "label[for=\"role\"]"
      assert_dom node, "select[name=\"user[role_id]\"]", 0
      assert_dom node, "div[class=\"ov-text\"]"
    end
  end


  context "date field" do
    helperSetup object: :create_person,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      helper.form_with model: object do |form|
        helper.set_ov_form form
        elem = helper.ov_date_field(:date_of_birth)
        node = Nokogiri::HTML(elem)
        assert_dom node, "label[for=\"date_of_birth\"]"
        assert_dom node, "input[name=\"person[date_of_birth]\"][type=\"date\"]"
        assert_dom node, "div[class=\"ov-text\"]", 0
      end
    end
    it "text" do
      helper.set_ov_form nil
      elem = helper.ov_date_field(:date_of_birth)
      node = Nokogiri::HTML(elem)
      assert_dom node, "label[for=\"date_of_birth\"]"
      assert_dom node, "input[name=\"person[date_of_birth]\"]", 0
      assert_dom node, "div[class=\"ov-text\"]"
    end
  end

  context "datetime field" do
    helperSetup object: :create_student,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      helper.form_with model: object do |form|
        helper.set_ov_form form
        elem = helper.ov_datetime_field(:created_at)
        node = Nokogiri::HTML(elem)
        assert_dom node, "label[for=\"created_at\"]"
        assert_dom node, "input[name=\"student[created_at]\"][type=\"datetime-local\"]"
        assert_dom node, "div[class=\"ov-text\"]", 0
      end
    end
    it "text" do
      helper.set_ov_form nil
      elem = helper.ov_datetime_field(:created_at)
      node = Nokogiri::HTML(elem)
      assert_dom node, "label[for=\"created_at\"]"
      assert_dom node, "input[name=\"student[created_at]\"]", 0
      assert_dom node, "div[class=\"ov-text\"]"
    end
  end

  after(:all) do
    unless User.count == 0
      ulist = User.all.map(&:inspect).join "\n"
      raise "nonzero User count #{self.inspect}\n#{ulist}\n#{destroy_list.size}"
    end
  end
end
