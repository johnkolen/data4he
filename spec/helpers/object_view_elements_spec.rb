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

  context "text field" do
    helperSetup object: :create_student,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      helper.form_with model: object do |form|
        helper.set_ov_form form
        elem = helper.ov_text_field(:inst_id)
        node = Nokogiri::HTML(elem)
        assert_dom node, "label[for=\"inst_id\"]"
        assert_dom node, "input[name=\"student[inst_id]\"]"
        assert_dom node, "div[class=\"ov-text\"]", 0
      end
    end
    it "text" do
      helper.set_ov_form nil
      elem = helper.ov_text_field(:inst_id)
      node = Nokogiri::HTML(elem)
      assert_dom node, "label[for=\"inst_id\"]"
      assert_dom node, "input[name=\"student[inst_id]\"]", 0
      assert_dom node, "div[class=\"ov-text\"]"
    end
  end

  context "text area" do
    helperSetup object: :create_student,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      helper.form_with model: object do |form|
        helper.set_ov_form form
        elem = helper.ov_text_area(:inst_id)
        node = Nokogiri::HTML(elem)
        assert_dom node, "label[for=\"inst_id\"]"
        assert_dom node, "textarea[name=\"student[inst_id]\"]"
        assert_dom node, "div[class=\"ov-text\"]", 0
      end
    end
    it "text" do
      helper.set_ov_form nil
      elem = helper.ov_text_area(:inst_id)
      node = Nokogiri::HTML(elem)
      assert_dom node, "label[for=\"inst_id\"]"
      assert_dom node, "textarea[name=\"student[inst_id]\"]", 0
      assert_dom node, "div[class=\"ov-text\"]"
    end
  end

  context "password field" do
    helperSetup object: :create_user,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      helper.form_with model: object do |form|
        helper.set_ov_form form
        elem = helper.ov_password_field(:password)
        node = Nokogiri::HTML(elem)
        assert_dom node, "label[for=\"password\"]"
        assert_dom node, "input[name=\"user[password]\"]"
        assert_dom node, "div[class=\"ov-text\"]", 0
      end
    end
    it "text" do
      helper.set_ov_form nil
      elem = helper.ov_password_field(:password)
      node = Nokogiri::HTML(elem)
      assert_dom node, "label[for=\"password\"]"
      assert_dom node, "input[name=\"user[password]\"]", 0
      assert_dom node, "div[class=\"ov-text\"]"
    end
  end

  context "checkbox" do
    helperSetup object: :create_phone_number,
                user: :admin_user
    before :each do
      helper.set_ov_obj object
    end
    it "form" do
      # don't need the form DOM element and it's path
      #helper.class.define_method :polymorphic_path do |obj, *arg, **other|
      #    ""
      #end
      pnp = helper.class.respond_to? :phone_number_path
      unless pnp
        helper.class.define_method :phone_number_path do |obj, *arg, **other|
          ""
        end
      end
      helper.form_with model: object do |form|
        helper.set_ov_form form
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
      helper.set_ov_form nil
      elem = helper.ov_checkbox(:active)
      node = Nokogiri::HTML(elem)
      assert_dom node, "label[for=\"active\"]"
      assert_dom node, "input[name=\"phone_number[active]\"]", 0
      assert_dom node, "input[onclick=\"return false\"]"
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
