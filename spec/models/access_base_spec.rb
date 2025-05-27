require 'rails_helper'

RSpec.describe AccessBase, type: :model do
  Node = AccessBase::Node
  ADX = AccessBase::Node::ADX
  LabelX = AccessBase::Node::LabelX
  RoleX = AccessBase::Node::RoleX
  describe Node do
    describe ADX do
      let(:klass) { ADX }
      let(:adx) { klass.new }
      it 'initializes' do
        expect(adx).to be_a ADX
        expect(adx).to be_empty
        expect(adx.member? :role).to eq false
        expect(adx[:role]).to be_nil
        expect(adx.allow?).to be_nil
        expect(adx.deny?).to be_nil
      end

      it "adds allow" do
        r = adx.add :allow, :child
        expect(adx).not_to be_empty
        expect(adx[:allow]).to eq :child
        expect(adx.member? :allow).to eq true
        expect(adx.allow?).to be true
        expect(adx.deny?).to be false
      end
    end

    describe LabelX do
      let(:klass) { LabelX }
      let(:lx) { klass.new }
      it 'initializes' do
        expect(lx).to be_a LabelX
        expect(lx).to be_empty
        expect(lx.member? :kind).to eq false
        expect(lx[:kind]).to be_nil
        expect(lx.allow? :kind).to be_nil
        expect(lx.deny? :kind).to be_nil
      end

      it "adds" do
        r = lx.add :kind, :allow
        expect(lx).not_to be_empty
        expect(lx[:kind]).to be_a ADX
        expect(lx.member? :kind).to eq true
        expect(lx.allow? :kind).to eq true
        expect(lx.deny? :kind).to eq false
        expect(lx.through :kind, :allow).to be_a AccessBase::Node
        expect(lx.allow? :notkind).to be_nil
      end
    end

    describe RoleX do
      let(:klass) { RoleX }
      let(:rx) { klass.new }
      it 'initializes' do
        expect(rx).to be_a RoleX
        expect(rx).to be_empty
        expect(rx.member? :role).to eq false
        expect(rx.allow? :role, :kind).to be_nil
        expect(rx.deny? :role, :kind).to be_nil
        expect(rx[:role]).to be_nil
      end

      it "adds" do
        r = rx.add :role, :kind, :allow
        expect(rx).not_to be_empty
        expect(rx[:role]).to be_a LabelX
        expect(rx.member? :role).to eq true
        expect(rx.allow? :role, :kind).to eq true
        expect(rx.deny? :role, :kind).to eq false
        expect(rx.through :role, :kind, :allow).to be_a AccessBase::Node
        expect(rx.deny? :notrole, :kind).to be_nil
      end
    end

    describe Node do
      let(:klass) { Node }
      let(:n) { klass.new }
      it 'initializes' do
        expect(n).to be_a Node
        expect(n).to be_empty
        expect(n.member? Student).to eq false
        expect(n.allow? Student, :role, :kind).to be_nil
        expect(n.deny? Student, :role, :kind).to be_nil
        expect(n[:role]).to be_nil
      end
      it "adds" do
        r = n.add Student, :role, :kind, :allow
        expect(n).not_to be_empty
        expect(n[Student]).to be_a RoleX
        expect(n.member? Student).to eq true
        expect(n.allow? Student, :role, :kind).to eq true
        expect(n.deny? Student, :role, :kind).to eq false
        expect(n.through Student, :role, :kind, :allow).to be_a AccessBase::Node
        expect(n.allow? Person, :role, :kind).to be_nil
      end
    end
  end

  class ATest < AccessBase
    define_access :view
  end

  context "labels" do
    it "has one" do
      expect(ATest.labels.size).to eq 1
    end
  end
  context "current user" do
    access = Class.new ATest
    it "gets and sets" do
      access.user = :user
      expect(access.user).to eq :user
    end
  end

  context "allow" do
    before(:all) do
      @student_user = create(:student_user)
      @student = create(:student, person: @student_user.person)
      @admin_user = create(:admin_user)
      @person = create(:person)
      expect(@student).not_to be_nil
    end

    after(:all) do
      @student_user.destroy
      @admin_user.destroy
      @person.destroy
    end

    it "allows simple" do
      access = Class.new ATest do
        allow :view, Student, :admin
      end
      expect(access.size).to eq 1
      expect(access.allow? Student, :view, :admin).to eq true
      expect(access.allow? Person, :view, :admin).to eq false
      expect(@student).not_to be_nil
      expect(access.allow? @student, :view, :admin).to eq true
      expect(access.allow? @person, :view, :admin).to eq false
    end
    it "allows combined access" do
      access = Class.new ATest do
        define_access :both, [ :edit, :view ]
        allow :both, Student, :admin
      end
      expect(access.allow? Student, :edit, :admin).to eq true
      expect(access.allow? Student, :view, :admin).to eq true
      expect(access.allow? Person, :view, :admin).to eq false
      expect(access.allow? Person, :edit, :admin).to eq false
    end
    it "allows combined roles" do
      access = Class.new ATest do
        allow :view, Student, [ :admin, :support ]
      end
      expect(access.allow? Student, :view, :admin).to eq true
      expect(access.allow? Student, :view, :support).to eq true
      expect(access.allow? Student, :view, :hr).to eq false
      expect(access.allow? Person, :view, :admin).to eq false
      expect(access.allow? Person, :edit, :support).to eq false
    end
    it "allows nested" do
      access = Class.new ATest do
        allow :view, Student, :admin do
          allow :view, Person, :admin
        end
      end
      expect(access.size).to eq 2
      n0 = access.node
      r = access.allow? Student, :view, :admin do
        #puts "-" * 30
        #puts access.explain
        #puts "=" * 30
        expect(access.last_label).to eq :view
        n = access.node
        expect(n).not_to be n0
        expect(access.allow? :attribute, :view, :admin).to eq true
        #puts "-" * 30
        #puts access.explain
        #puts "=" * 30
        expect(access.allow? Person, :view, :admin).to eq true
        expect(access.node).to be n
        expect(access.allow? User, :view, :admin).to eq false
      end
      expect(access.node).to be n0
      expect(r).to eq true
    end

    it "allows person self" do
      access = Class.new ATest do
        allow :view, Person, :self
      end
      expect(access.size).to eq 1
      expect(@student_user.is_self? @student_user.person).to be true
      expect(@student_user.is_self? @person).to be false
      access.user = @student_user
      expect(access.allow? @student_user.person, :view, :self).to eq true
      expect(access.allow? @person, :view, :self).to eq false
    end
  end
  context "denies" do
    it "nested" do
      access = Class.new ATest do
        allow :view, Student, :admin do
          deny :view, :catalog_year_id, :admin
        end
      end
      expect(access.size).to eq 2
      n0 = access.node
      r = access.allow? Student, :view, :admin do
        n = access.node
        expect(n).not_to be n0
        expect(access.allow? :catalog_year_id, :view, :admin).to eq false
        expect(access.node).to be n
      end
      expect(access.node).to be n0
      expect(r).to eq true
    end
    it "nested self" do
      access = Class.new ATest do
        allow :view, Person, :self do
          deny :view, :ssn, :self
        end
      end
      expect(access.size).to eq 2
      expect(access.node).to be_nil
      p = create(:person)
      access.user = create(:user, person: p)
      # expect(access.allow? Person, :view, :admin).to eq true
      n0 = access.node
      r = access.allow? p, :view, :self do
        n = access.node
        expect(n).not_to be n0
        expect(access.allow? :ssn, :view, :self).to eq false
        expect(access.node).to be n
      end
      expect(access.node).to be n0
      expect(r).to eq true
    end
    it "allows nested like Access" do
      access = Class.new ATest do
        allow [:view, :edit], Student, :self do
          allow :edit, Person, :self
        end
      end
      tree = access.tree_str
      expect(tree.scan(/Student/).size).to eq 1
    end
    it "allows nested like Access xx" do
      access = Class.new ATest do
        allow [:view, :edit], Student, :self do
          allow :edit, Person, :self
        end
      end
      tree = access.tree_str
      expect(tree.scan(/Student/).size).to eq 1
    end
    it "blocks editing of attribute" do
      s = create(:student)
      access = Class.new AccessBase do
        define_access :view
        define_access :edit
        allow [:view, :edit], Student, :admin do
          deny :edit, :inst_id, :admin
        end
      end
      #puts access.tree_str
      r = access.allow? s, :edit, :admin do
        expect(access.allow? :calendar_year_id, :edit, :admin).to eq true
        #puts "-" * 30
        #puts access.explain
        #puts "=" * 30
        expect(access.allow? :inst_id, :edit, :admin).to eq false
        #puts "-" * 30
        #puts access.explain
        #puts "=" * 30
        # following returns false since in the context editing Student
        # the default is able to edit, but in this case its denied
        # and viewing is not specified
        expect(access.allow? :inst_id, :view, :admin).to eq false
        #puts "-" * 30
        #puts access.explain
        #puts "=" * 30
      end
      expect(r).to be true
    end
    it "blocks editing of attribute but allows viewing" do
      s = create(:student)
      access = Class.new AccessBase do
        define_access :view
        define_access :edit
        allow [:view, :edit], Student, :admin do
          deny :edit, :inst_id, :admin
          allow :view, :inst_id, :admin
        end
      end
      #puts access.tree_str
      r = access.allow? s, :edit, :admin do
        expect(access.allow? :calendar_year_id, :edit, :admin).to eq true
        #puts "-" * 30
        #puts access.explain
        #puts "=" * 30
        expect(access.allow? :inst_id, :edit, :admin).to eq false
        #puts "-" * 30
        #puts access.explain
        #puts "=" * 30
        expect(access.allow? :inst_id, :view, :admin).to eq true
        #puts "-" * 30
        #puts access.explain
        #puts "=" * 30
      end
      expect(r).to be true
    end
  end
end
