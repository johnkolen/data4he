module ControllerSetup
  def controllerSetup obj, objs
    return unless obj || objs
    @klass = eval(controller.controller_path.classify)
    @klass_str = @klass.to_s
    @klass_sym = @klass.to_s.downcase.to_sym
    @klass_p_str = @klass.to_s.pluralize

    if obj
      assign(@klass_sym, obj)
      assign(:object, obj)
    end

    if objs
      assign(@klass_sym.to_s.pluralize.to_sym, objs)
      assign(:objects, objs)
    end

    assign(:klass, @klass)
    assign(:klass_str, @klass_str)
    assign(:klass_sym, @klass_sym)
    assign(:klass_p_str, @klass_p_str)
  end

  def accessSetup user_sym
    raise "access user id = #{Access.user.inspect}" if Access.user
    Access.user = create(user_sym)
    destroy_list << Access.user
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def builder sym
    case sym.to_s
    when /^create_(.*)/
      create $1.to_sym
    when /^build_(.*)/
      build $1.to_sym
    else
      sym
    end
  end

  def object
    self.class.setup_object
  end

  def objects
    self.class.setup_objects
  end

  def destroy_list
    self.class.destroy ||= []
  end

  def cleanup_objects
    destroy_list.each{|x| x.destroy if x && x.persisted?}
    Access.user = nil
  end

  module ClassMethods
    attr_accessor :setup_object
    attr_accessor :setup_objects
    attr_accessor :setup_user
    attr_accessor :destroy

    def setup_all inst
      if setup_object && setup_object.is_a?(Symbol)
        destroy << (setup_object = inst.builder(setup_object))
      end
      if setup_objects
        setup_objects = setup_objects.map do |x|
          if x.is_a? Symbol
            destroy << inst.builder
            destroy.last
          else
            x
          end
        end
      end
    end

    def classSetup **options
      @setup_object = options[:object]
      @setup_objects = options[:objects]
      @setup_user = options[:user]
      @destroy = []

      before :all do
        self.class.setup_all self
      end

      before :each do
        controllerSetup self.class.setup_object,
                        self.class.setup_objects
        accessSetup self.class.setup_user || :admin_user
        sign_in(Access.user, scope: :user) if Access.user
      end

      after :all do
        self.cleanup_objects
      end
    end

    def accessSetup user_sym
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
