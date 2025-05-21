require 'rails_helper'

RSpec.describe Access, type: :model do

  def self.build_ad resource,
                    labels,
                    **outcomes
    outcomes.each do |tgt, roles|
      msg = tgt ? "allows" : "denies"
      roles.each do |role|
        labels.each do |label|
          it "#{msg} #{role} #{label}" do
            expect( Access.allow? resource, label, role ).to eq tgt
          end
        end
      end
    end
  end

  context 'Root' do
    build_ad Access::Root,
             [:view, :edit, :delete, :index ],
             true => [:admin],
             false => [:badhat]
  end

  context 'Student' do
    build_ad Student,
             [:view, :edit ],
             true => [:administration, :registrar, :student],
             false => [:badhat]
    build_ad Student,
             [:index],
             true => [:admin, :administration, :registrar],
             false => [:student, :badhat]
  end

  context 'Person' do
    before :all do
      @s = create(:student)
      @u = create(:user, person_id: @s.person_id)
      expect(@u).not_to be_nil
      @o = create(:student_1)
      Access.user = @u
    end
    context "self" do
      it 'edit' do
        expect(@u.is_self? @u.person).to be true
        expect(Access.allow? @s.person, :edit, :self).to be true
        expect(Access.allow? @o.person, :edit, :self).to be false
      end
    end
    it 'nested edit' do
      r1 = nil
      r = Access.allow? @s.person, :edit, :self do
        expect(Access.allow? :date_of_birth, :edit, :self).to eq true
        expect(Access.allow? :ssn, :edit, :self).to eq false
      end
      expect(r).to eq true
    end
  end
end
