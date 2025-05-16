class AcademicYear < ApplicationRecord
  has_many :students, inverse_of: :catalog_year
end
