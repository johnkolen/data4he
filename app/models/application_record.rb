class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  include ToParams

  def add_builds!
  end
end
