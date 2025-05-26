require 'rails_helper'

RSpec.describe Access, type: :model do
  def self.bulk_ad resource,
                    labels,
                    **outcomes
    outcomes.each do |tgt, roles|
      msg = tgt ? "allows" : "denies"
      roles.each do |role|
        labels.each do |label|
          it "#{msg} #{role} #{label}" do
            expect(Access.allow? resource, label, role).to eq tgt
          end
        end
      end
    end
  end

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

  context 'Root bulk' do
    bulk_ad Access::Root,
             [ :view, :edit, :delete, :index ],
             true => [ :admin ],
             false => [ :badhat ]
    bulk_ad Student,
             [ :view, :edit, :delete, :index ],
             true => [ :admin ],
             false => [ :badhat ]
  end

  context 'Student bulk' do
    bulk_ad Student,
             [ :view, :edit ],
             true => [ :administration, :registrar, :admin ],
             false => [ :badhat, :student ]
    bulk_ad Student,
             [ :index ],
             true => [ :admin, :administration, :registrar ],
             false => [ :student, :badhat ]
  end

  context 'Student self' do
    before :all do
      Access.user = @student_user
    end
    after :all do
      Access.user = nil
    end
    it "with self user" do
      expect(Access.user.is_self?(@student)).to be true
      expect(Access.allow?(Student, :edit)).to eq false
    end
  end

  context 'Person' do
    before :all do
      Access.user = @student_user
    end
    after :all do
      Access.user = nil
    end
    context "self" do
      it 'edit' do
        expect(@student_user.is_self? @student.person).to be true
        expect(Access.allow? @student_user.person, :edit, :self).to be true
        expect(Access.allow? @student.person, :edit, :self).to be true
        expect(Access.allow? @person, :edit, :self).to be false
      end
    end
    it 'nested edit' do
      r1 = nil
      r = Access.allow? @student.person, :edit, :self do
        expect(Access.allow? :date_of_birth, :edit, :self).to eq true
        expect(Access.allow? :ssn, :edit, :self).to eq false
      end
      expect(r).to eq true
    end
  end
  context 'User' do
    before :all do
      Access.user = @student_user
    end
    after :all do
      Access.user = nil
    end
    it "recognize self" do
      Access.allow? Access.user, :edit
    end
  end
end
