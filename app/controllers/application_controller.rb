class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def set_klass
    @klass = eval(controller_name.classify)
    @klass_str = @klass.to_s
    @klass_sym = @klass.to_s.downcase.to_sym
    @klass_p_str = @klass.to_s.pluralize
  end

end
