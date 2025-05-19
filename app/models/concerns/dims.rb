require "active_support/concern"

module Dims
  extend ActiveSupport::Concern

  included do
    def is_dim?(x)
      self.class.dims[x.to_sym]
    end
  end

  module ClassMethods
    attr_accessor :dims
    def dim *list
      @dims ||= {}
      list.each do |x|
        @dims[x] = true
        if /(.*)_id$/ =~ x.to_s
          @dims[$1.to_sym] = true
        else
          @dims[:"#{x}_id"] = true
        end
      end
    end
    def is_dim?(x)
      self.dims[x.to_sym]
    end
  end
end
