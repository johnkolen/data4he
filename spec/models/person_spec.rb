require 'rails_helper'

RSpec.describe Person, type: :model do
  before :each do
    @p = Person.new
  end

  it 'has meta parameters' do
    @p.first_name = 'xyz'
    expect(@p.first_name_str).to eq 'xyz'
  end

  it 'checks ssn format' do
    @p.first_name = 'Alex'
    @p.ssn = 'xyz'
    expect(@p.valid?).to eq false
    expect(/#{Person::SSN_RE_STR}/.match? '123-45-7890').to eq true
    @p.ssn = '123-45-7890'
    expect(@p.valid?).to eq(true), "#{@p.errors.inspect}"
  end

  it 'has phone_numbers label' do
    expect(@p.phone_numbers_label).to eq "Phone numbers"
  end

  it 'accepts nested attributes' do
    p = Person.new first_name: 'Alex',
                   last_name: 'Alpha',
                   ssn: '123-12-1234',
                   phone_numbers_attributes: {
                     "0" => {number: '(123)456-9876',
                             primary: '1',
                             active: '1'}
                   }
    expect {
      expect {
        p.save!
      }.to change{Person.count}.by(1)
    }.to change{PhoneNumber.count}.by(1)
    expect(p.persisted?)
    q = Person.find(p.id)
    expect(q.phone_numbers[0].number).to eq '(123)456-9876'
  end

  it 'generates parameters' do
    h = build(:person).to_params
    expect(h).to be_a Hash
  end

  it 'destroys nested attributes' do
    params = {first_name: 'Alex',
                   last_name: 'Alpha',
                   ssn: '123-12-1234',
                   phone_numbers_attributes: {
                     "0" => {number: '(123)456-9876',
                             primary: '1',
                             active: '1'}
                   }
             }
    p = Person.new **params
    expect {
      expect {
        p.save!
      }.to change{Person.count}.by(1)
    }.to change{PhoneNumber.count}.by(1)
    expect(p.persisted?)
    q = Person.find(p.id)
    expect(q.phone_numbers[0].number).to eq '(123)456-9876'
    pn_id = p.phone_numbers.first.id
    params[:phone_numbers_attributes]["0"][:_destroy] = 1
    params[:phone_numbers_attributes]["0"][:id] = pn_id
    expect {
      expect {
        p.update(params)
      }.to change{Person.count}.by(0)
    }.to change{PhoneNumber.count}.by(-1)
  end
end
