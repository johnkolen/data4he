class Person < ApplicationRecord
  has_many :phone_numbers, inverse_of: :person
  accepts_nested_attributes_for :phone_numbers

  # use same regex for both client- and server-side validation
  # single quotes due to possible regex backslashes
  SSN_RE_STR = '[0-9]{3}-[0-9]{2}-[0-9]{4}'

  validates :first_name, presence: true
  validates :ssn, format: {
              with: /#{SSN_RE_STR}/,
              message: "SSN must be of the form 123-45-6789"
            }

  include MetaAttributes

  def ssn_pattern
    SSN_RE_STR
  end

  def ssn_label
    "SSN"
  end
end
