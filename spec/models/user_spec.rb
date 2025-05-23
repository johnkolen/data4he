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
    u.destroy
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

  context 'is self' do
    before :all do
      @u = create(:user)
      @v = create(:student_user)
    end
    after :all do
      @u.destroy
      @v.destroy
    end
    it 'from same user' do
      expect(@u.is_self? @u).to eq true
    end
    it 'from other user' do
      expect(@u.is_self? @v).to eq false
    end
  end
end
