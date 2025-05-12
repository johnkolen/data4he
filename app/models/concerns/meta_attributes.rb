require "active_support/concern"

module MetaAttributes
  extend ActiveSupport::Concern

  included do
    def method_missing name, *args, &block
      case name
      when /^(.*)_str$/
        if attribute_names.member? $1
          return send($1).to_s
        end
      when /^(.*)_label$/
        if attribute_names.member? $1
          return $1.humanize
        end
      when /^(.*)_pattern$/
        if attribute_names.member? $1
          return nil
        end
      end
      super
    end

    def respond_to? name, include_private = false
      case name
      when /^(.*)_str$/,
           /^(.*)_label$/,
           /^(.*)_pattern$/
        return true if attribute_names.member? $1
      end
      super
    end
  end
end
