module ControllerSetup
  def controllerSetup(obj, objs)
    # return unless obj || objs
    if controller
      @klass = eval(controller.controller_path.classify)
      @klass_str = @klass.to_s
      @klass_sym = @klass.to_s.underscore.to_sym
      @klass_p_str = @klass.to_s.pluralize
    end

    if obj
      assign(@klass_sym, obj) if @klass_sym
      assign(:object, obj)
    end

    if objs
      assign(@klass_sym.to_s.pluralize.to_sym, objs) if @klass_sym
      assign(:objects, objs)
    end

    if @klass
      assign(:klass, @klass)
      assign(:klass_str, @klass_str)
      assign(:klass_sym, @klass_sym)
      assign(:klass_p_str, @klass_p_str)
    end
  end

  def accessSetup(user_sym)
    Access.user = create(user_sym)
    destroy_list << Access.user
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def builder(sym)
    case sym.to_s
    when /^create_(.*)/
      create $1.to_sym
    when /^build_(.*)/
      build $1.to_sym
    else
      sym
    end
  end

  def s_object
    self.class.setup_object
  end

  def s_object=(obj)
    self.class.setup_object = obj
    self.class.setup_object
  end

  def s_objects
    self.class.setup_objects
  end

  def s_objects=(objs)
    self.class.setup_objects = objs
    self.class.setup_objects
  end

  def destroy_list
    self.class.destroy ||= []
  end

  def cleanup_objects
    destroy_list.each { |x| x.destroy if x && x.persisted? }
    Access.user = nil
  end

  def setup_all
    if s_object && s_object.is_a?(Symbol)
      destroy_list << builder(s_object)
      self.s_object = destroy_list.last
    end

    if s_objects
      self.s_objects = s_objects.map do |x|
        if x.is_a? Symbol
          destroy_list << builder(x)
          destroy_list.last
        else
          x
        end
      end
    end
  end

  module ClassMethods
    attr_accessor :setup_object
    attr_accessor :setup_objects
    attr_accessor :setup_user
    attr_accessor :destroy

    def classSetup **options
      @setup_object = options[:object]
      @setup_objects = options[:objects]
      @setup_user = options[:user]
      @destroy = []

      before :all do
        setup_all
      end

      let (:object) { s_object }
      let (:objects) { s_objects }

      before :each do
        controllerSetup s_object,
                        s_objects
        accessSetup self.class.setup_user || :admin_user
        sign_in(Access.user, scope: :user) if Access.user
      end

      after :all do
        cleanup_objects
      end
    end

    def accessSetup(user_sym)
      @destroy = []
      before :all do
        accessSetup user_sym
      end
      after :all do
        self.class.cleanup_objects
      end
    end
  end
end
