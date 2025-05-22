module ControllerSetup
  def controllerSetup obj
    @klass = eval(controller.controller_path.classify)
    @klass_str = @klass.to_s
    @klass_sym = @klass.to_s.downcase.to_sym
    @klass_p_str = @klass.to_s.pluralize
    assign(@klass_sym, obj)
    assign(:object, obj)
    assign(:klass, @klass)
    assign(:klass_str, @klass_str)
    assign(:klass_sym, @klass_sym)
    assign(:klass_p_str, @klass_p_str)
  end
end
