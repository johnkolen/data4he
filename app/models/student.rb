class Student < ApplicationRecord
  belongs_to :person
  belongs_to :catalog_year

  accepts_nested_attributes_for :person

  validates :person_id, presence: true
  validates :catalog_year_id, presence: true

  include MetaAttributes

end
