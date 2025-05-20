require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }
  context "when admin" do
    let(:user) { create :admin_user }
    [Person, Student, User].each do |klass|
      it { is_expected.to be_able_to(:manange, klass) }
      it { is_expected.to be_able_to(:read, klass) }
    end
  end

  context "when student" do
    let(:user) {
      s = create(:student)
      puts s.inspect
      create :user, role_id: User::RoleStudent, person_id: s.person_id
    }
    #let(:s1) { create(:student_1) }
    let(:s) { Student.where(person_id: user.person_id).first }
    it { is_expected.to be_able_to(:read, Student) }
    it { is_expected.to be_able_to(:read, s) }
    it {
      puts user.person_id
      s1 = create(:student_1)
      puts s1.id
      is_expected.not_to be_able_to(:read, s1)
    }
  end
end
