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
    class A000 < ATest
    end
    it "gets and sets" do
      A000.user = :user
      expect(A000.user).to eq :user
    end
  end
  context "allow" do
    it "allows simple" do
      class A001 < ATest
      end
      A001.allow :view, Student, :admin
      expect(A001.size).to eq 1
      expect(A001.allow? Student, :view, :admin).to eq true
      expect(A001.allow? Person, :view, :admin).to eq false
      s = create(:student)
      expect(A001.allow? s, :view, :admin).to eq true
      p = create(:person)
      expect(A001.allow? p, :view, :admin).to eq false
    end
    it "allows combined access" do
      class A002 < ATest
        define_access :edit
        define_access :both, [:edit, :view]
      end
      A002.allow :both, Student, :admin
      expect(A002.allow? Student, :edit, :admin).to eq true
      expect(A002.allow? Student, :view, :admin).to eq true
      expect(A002.allow? Person, :view, :admin).to eq false
      expect(A002.allow? Person, :edit, :admin).to eq false
    end
    it "allows combined roles" do
      class A003 < ATest
      end
      A003.allow :view, Student, [:admin, :support]
      expect(A003.allow? Student, :view, :admin).to eq true
      expect(A003.allow? Student, :view, :support).to eq true
      expect(A003.allow? Student, :view, :hr).to eq false
      expect(A003.allow? Person, :view, :admin).to eq false
      expect(A003.allow? Person, :edit, :support).to eq false
    end
    it "allows nested" do
      class A004 < ATest
      end
      A004.allow :view, Student, :admin do
        A004.allow :view, Person, :admin
      end
      expect(A004.size).to eq 2
      n0 = A004.node
      r = A004.allow? Student, :view, :admin do
        n = A004.node
        expect(n).not_to be n0
        expect(A004.allow? :attribute, :view, :admin).to eq true
        expect(A004.allow? Person, :view, :admin).to eq true
        expect(A004.node).to be n
        expect(A004.allow? User, :view, :admin).to eq false
      end
      expect(A004.node).to be n0
      expect(r).to eq true
    end
    it "allows person self" do
      class A005 < ATest
      end
      A005.allow :view, Person, :self
      expect(A005.size).to eq 1
      u = create(:student_user)
      o = create(:student_user_1)
      expect(u.is_self? u.person).to be true
      expect(u.is_self? o.person).to be false
      A005.user = u
      expect(A005.allow? u.person, :view, :self).to eq true
      expect(A005.allow? o.person, :view, :self).to eq false
    end
  end
  context "denies" do
    it "nested" do
      class A006 < ATest
      end
      A006.allow :view, Student, :admin do
        A006.deny :view, :catalog_year_id, :admin
      end
      expect(A006.size).to eq 2
      n0 = A006.node
      r = A006.allow? Student, :view, :admin do
        n = A006.node
        expect(n).not_to be n0
        expect(A006.allow? :catalog_year_id, :view, :admin).to eq false
        expect(A006.node).to be n
      end
      expect(A006.node).to be n0
      expect(r).to eq true
    end
    it "nested self" do
      class A007 < ATest
      end
      A007.allow :view, Person, :self do
        A007.deny :view, :ssn, :self
      end
      expect(A007.size).to eq 2
      expect(A007.node).to be_nil
      p = create(:person)
      A007.user = create(:user, person: p)
      #expect(A007.allow? Person, :view, :admin).to eq true
      n0 = A007.node
      r = A007.allow? p, :view, :self do
        n = A007.node
        expect(n).not_to be n0
        expect(A007.allow? :ssn, :view, :self).to eq false
        expect(A007.node).to be n
      end
      expect(A007.node).to be n0
      expect(r).to eq true
    end
  end
end
