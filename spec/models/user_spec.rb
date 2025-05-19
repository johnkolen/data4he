require 'rails_helper'
require 'cancan/matchers'

RSpec.describe User, type: :model do
  before :each do
    @u = User.new
  end
  it 'has meta parameters' do
    @u.email = 'xyz@demo.com'
    expect(@u.email_str).to eq @u.email
    expect(@u.email_label).to eq "Email"
    @u.password = 'xyz321'
    expect(@u.password_str).to eq "xyz321"
    expect(@u.password_label).to eq "Password"
  end

  it 'creates' do
    u = User.new email: "abc@demo.edu",
                 password: "12345678",
                 password_confirmation: "12345678"
    u.save!
    expect(u.persisted?).to eq true
  end

  context 'roles' do
    context 'tests' do
      it 'admin?' do
        @u.role_id = User::RoleAdmin
        expect(@u.admin?).to eq true
        @u.role_id = User::RoleNone
        expect(@u.admin?).to eq false
      end
    end
  end

  describe 'abilities' do
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
        create :user, person_id: s.person_id
      }
      let(:s1) { create(:student_1) }
      let(:s) { s = Student.where(person_id: user.person_id).first }
      it { is_expected.to be_able_to(:read, Student) }
      it { is_expected.to be_able_to(:read, s) }
      it { is_expected.not_to be_able_to(:read, s1) }
    end
  end
end
