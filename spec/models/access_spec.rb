require 'rails_helper'

RSpec.describe Access, type: :model do
  it 'prints tree' do
    puts Access.tree_str
  end
  def allow? label, who=nil
    Access.allow? target, label, who
  end

  context 'access root access' do
    let(:target) { AccessRoot }
    [:admin].each do |role|
      [:view, :edit, :delete, :index ].each do |label|
        it "allows #{role} #{label}" do
          expect( allow? label, role ).to eq true
        end
      end
    end
    [:badhat].each do |role|
      it "denys #{role}" do
        expect( allow? :view, role ).to eq false
      end
    end
  end

  context 'student access' do
    let(:target) { Student }
    [:administration].each do |role|
      it "allows #{role} view" do
        expect( allow? :view, role ).to eq true
      end
    end
    [:admin].each do |role|
      it "allows #{role} index" do
        expect( allow? :index, role ).to eq true
        Access.user = build(:admin_user)
        expect( allow? :index ).to eq true
      end
    end
    [:badhat].each do |role|
      it "denys #{role}" do
        expect( allow? :view, role ).to eq false
      end
    end
    it 'self edit' do
      u = create(:student_user)
      o = create(:student_user_1)
      expect(u.is_self? u.person).to be true
      #puts u.person.inspect
      #puts o.person.inspect
      Access.user = u
      expect(Access.allow? u.person, :edit, :self).to be true
      expect(Access.allow? o.person, :edit, :self).to be false
    end
  end

  context 'person access' do
    let(:target) { Person }
    it 'nested edit' do
      r1 = nil
      Access.user = create(:student_user)
      r0 = Access.allow? Person, :edit, :self do
        r1 = Access.allow? :ssn, :edit, :self
      end
      expect(r0).to eq true
      expect(r1).to eq false
    end
  end
end
