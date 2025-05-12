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
end
