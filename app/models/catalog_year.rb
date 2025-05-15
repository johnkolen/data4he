class AcademicYear < ApplicationRecord
  has_many students, foriegn_key: "catalog_year_id"
end
