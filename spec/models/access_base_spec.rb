require 'rails_helper'

RSpec.describe AccessBase, type: :model do
  Node = AccessBase::Node
  ADX = AccessBase::Node::ADX
  KindX = AccessBase::Node::KindX
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
        expect(adx.allow?).to be false
      end

      it "adds allow" do
        r = adx.add :allow, :child
        expect(adx).not_to be_empty
        expect(adx[:allow]).to eq :child
        expect(adx.member? :allow).to eq true
        expect(adx.allow?).to be true
      end
    end

    describe KindX do
      let(:klass) { KindX }
      let(:kx) { klass.new }
      it 'initializes' do
        expect(kx).to be_a KindX
        expect(kx).to be_empty
        expect(kx.member? :kind).to eq false
        expect(kx[:kind]).to be_nil
        expect(kx.allow? :kind).to eq false
      end

      it "adds" do
        r = kx.add :kind, :allow
        expect(kx).not_to be_empty
        expect(kx[:kind]).to be_a ADX
        expect(kx.member? :kind).to eq true
        expect(kx.allow? :kind).to eq true
        expect(kx.through :kind, :allow).to be_a AccessBase::Node
      end
    end

    describe RoleX do
      let(:klass) { RoleX }
      let(:rx) { klass.new }
      it 'initializes' do
        expect(rx).to be_a RoleX
        expect(rx).to be_empty
        expect(rx.member? :role).to eq false
        expect(rx.allow? :role, :kind).to eq false
        expect(rx[:role]).to be_nil
      end

      it "adds" do
        r = rx.add :role, :kind, :allow
        expect(rx).not_to be_empty
        expect(rx[:role]).to be_a KindX
        expect(rx.member? :role).to eq true
        expect(rx.allow? :role, :kind).to eq true
        expect(rx.through :role, :kind, :allow).to be_a AccessBase::Node
      end
    end

    describe Node do
      let(:klass) { Node }
      let(:n) { klass.new }
      it 'initializes' do
        expect(n).to be_a Node
        expect(n).to be_empty
        expect(n.member? Student).to eq false
        expect(n.allow? Student, :role, :kind).to eq false
        expect(n[:role]).to be_nil
      end
      it "adds" do
        r = n.add Student, :role, :kind, :allow
        expect(n).not_to be_empty
        expect(n[Student]).to be_a RoleX
        expect(n.member? Student).to eq true
        expect(n.allow? Student, :role, :kind).to eq true
        expect(n.through Student, :role, :kind, :allow).to be_a AccessBase::Node
      end
    end

    class ATest < AccessBase
      define_access :view
    end
    context "allow" do
      it "allows simple" do
        class A001 < ATest
        end
        A001.allow :view, Student, :admin
        expect(A001.allow? Student, :view, :admin).to eq true
        expect(A001.allow? Person, :view, :admin).to eq false
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
        r1 = nil
        r0 = A004.allow? Student, :view, :admin do
          r1 = A004.allow? Person, :view, :admin
          r2 = A004.allow? User, :view, :admin
        end
        expect(r0).to eq true
        expect(r1).to eq true
        expect(r2).to eq false
      end
    end
  end
end
