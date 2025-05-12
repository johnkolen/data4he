require 'rails_helper'

RSpec.describe PhoneNumber, type: :model do
  before :each do
    @pn = PhoneNumber.new
  end
  it 'has meta parameters' do
    @pn.number = 'xyz'
    expect(@pn.number_str).to eq 'xyz'
  end

  it 'checks number format' do
    @pn.build_person
    @pn.number = 'xyz'
    expect(@pn.valid?).to eq false
    #expect(/#{PhoneNumber::NUMBER_RE_STR}/.match? '(123)456-7890').to eq true
    @pn.number = '(123)456-7890'
    expect(@pn.valid?).to eq true
  end

end
