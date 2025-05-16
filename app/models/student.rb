class Student < ApplicationRecord
  belongs_to :person, inverse_of: :student
  belongs_to :catalog_year, class_name: "AcademicYear"

  accepts_nested_attributes_for :person,
                                update_only: true  # allow partial updates

  validates :person, presence: true
  validates :catalog_year, presence: true

  include MetaAttributes

  def add_builds!
    build_person
    person.add_builds!
  end

  def catalog_year_str
    if catalog_year
      catalog_year.year.to_s
    else
      "none"
    end
  end

  def catalog_year_options
    r = self.class.reflect_on_association(:catalog_year)
    klass = eval(r.options[:class_name])
    klass.pluck(:year, :id).sort.reverse
  end
end
