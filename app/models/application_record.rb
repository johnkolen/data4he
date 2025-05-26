class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  include ToParams

  def add_builds!
  end

  def class_name_u
    self.class.to_s.underscore
  end

  def get_template
    cn = class_name_u
    path = "app/views/#{cn.pluralize}/_#{cn}.html.erb"
    h = {}
    File.open path do |f|
      f.each_line do |line|
        if /ov_(\w+) :(\w+)/ =~ line
          h[$2.to_sym] = $1.to_sym
        end
      end
    end
    h
  end

  def get_form fn="form"
    cn = class_name_u
    path = "app/views/#{cn.pluralize}/_#{fn}.html.erb"
    h = {}
    File.open path do |f|
      f.each_line do |line|
        if /ov_(\w+) :(\w+)/ =~ line
          h[$2.to_sym] = $1.to_sym
        end
      end
    end
    h
  end
end
