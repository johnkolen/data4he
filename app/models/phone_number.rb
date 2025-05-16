class PhoneNumber < ApplicationRecord
  belongs_to :person

  # use same regex for both client- and server-side validation
  # single quotes due to the regex backslashes
  NUMBER_RE_STR = '\([0-9]{3}\)[0-9]{3}-[0-9]{4}'

  validates :number, format: {
              with: /#{NUMBER_RE_STR}/,
              message: "phone numbers must be of the form (123)456-7890"
            }

  include MetaAttributes

  def number_pattern
    NUMBER_RE_STR
  end
end
