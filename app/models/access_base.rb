class AccessBase
  def self.labels
    @labels ||= {}
  end

  def self.define_access(label, values = nil)
    if values.is_a? Array
      labels[label] = values
    else
      labels[label] = [ values || label ]
    end
  end

  class Root
  end

  class Mapper
    def initialize
      @map = {}
    end
    def add(key, child = nil)
      if key.is_a? Array
        key.each do |k|
          add key, child
        end
      else
        @map[key] = child
      end
      child
    end
    def member?(key)
      @map.member? key
    end
    def empty?
      @map.empty?
    end
    def [](key)
      @map[key]
    end
    def through *keys
      t = @map[keys.first]
      return t if t.nil?
      keys.shift
      return t if t.is_a? Node
      t.through *keys
    end

    def size
      @map.values.inject(0) do |sum, x|
        sum + x.size
      end
    end

    def tree_str(indent = "")
      return "" if empty?
      out = []
      @map.each do |key, value|
        out << "#{indent}#{key}"
        if value.respond_to? :tree_str
          x = value.tree_str("#{indent}  ")
          out << x unless x.empty?
        else
          out << "#{indent}#{value.inspect}"
        end
      end
      out.join("\n").gsub(/\n\s+(allow|deny)/m, ': \1')
    end
  end

  class Node < Mapper
    class ADX < Mapper
      def add(ad, child = nil)
        raise "not allow or deny #{ad}" unless ad == :allow || ad == :deny
        super ad, child || Node.new
      end

      def allow?  # ADX
        return true if @map[:allow]
        return false if @map[:deny]
        nil
      end

      def deny?  # ADX
        return false if @map[:allow]
        return true if @map[:deny]
        nil
      end
    end

    class LabelX < Mapper
      def add(label, ad, child = nil)
        return self if member? label
        adx = ADX.new
        adx.add ad
        super label, adx
      end

      def allow?(label)  # LabelX
        adx = self[label]
        return nil unless adx
        adx.allow?
      end

      def deny?(label)  # LabelX
        adx = self[label]
        return nil unless adx
        adx.deny?
      end
    end

    class RoleX < Mapper
      def add(role, label, ad, child = nil)
        unless member? role
          lx = LabelX.new
          lx.add label, ad, child
          super role, lx
        else
          self[role].add label, ad, child
        end
        self
      end

      def allow?(role, label)  # RoleX
        lx = self[role]
        return nil unless lx
        lx.allow? label
      end

      def deny?(role, label)  # RoleX
        lx = self[role]
        return nil unless lx
        lx.deny? label
      end
    end

    def add(resource, role, label, ad, child = nil)
      unless member? resource
        rx = RoleX.new
        rx.add role, label, ad, child
        super resource, rx
      else
        self[resource].add role, label, ad, child
      end
    end

    def allow(resource, label, role)
      add resource, label, role, :allow
    end

    def deny(resource, label, role)
      add resource, label, role, :deny
    end

    def allow?(resource, role, label)  # Node
      rx = self[resource]
      return nil unless rx
      rx.allow? role, label
    end

    def deny?(resource, role, label)  # Node
      rx = self[resource]
      return nil unless rx
      rx.deny? role, label
    end

    def size
      (empty? ? 0 : 1) + super
    end
  end

  def self.root
    @root ||= Node.new
  end

  def self.node
    @node
  end

  # labels can be a single define label or an enumerable of defined labels
  # ad     can be :allow or :deny
  def self._allowdeny(labels, resource, roles, ad, &block)
    @current = @node || root
    expand(labels).each do |label|
      expand(roles).each do |role|
        # puts "#{label.inspect}  #{role.inspect} #{resource}"
        @current.add resource, role, label, ad
        if block_given?
          hold = [@node, @current]
          @node = @current.through resource, role, label, ad
          yield
          @node, @current = hold
        end
      end
    end
  end

  def self.allow(labels, resource, roles, &block)
    _allowdeny labels, resource, roles, :allow, &block
  end

  def self.deny(labels, resource, roles, &block)
    _allowdeny labels, resource, roles, :deny, &block
  end


  def self.size
    root.size
  end

  def self.tree_str
    root.tree_str
  end

  def self.expand(elems)
    if elems.is_a? Array
      elems.map { |elem| expand elem }.flatten
    else
      ex = labels[elems]
      if ex
        ex
      else
        [ elems ]
      end
    end
  end

  def self.force_class(obj)
    case obj
    when Symbol, Class
      obj
    else
      obj.class
    end
  end

  def self._allow?(resource, role, label)
    hold = [ @node, @last_obj ]
    begin
      if resource.is_a? Symbol
        # raise "cain #{resource} #{@node.deny?(force_class(resource), role, label)}"
        r = @node.deny?(resource, role, label)
        return !r unless r.nil?
        return true # attributes are accessible if they are reachable
      else
        # raise "cain #{force_class(resource).inspect}  #{@node.allow?(force_class(resource), role, label)}"
        r = @node.allow?(force_class(resource), role, label)
        # return nil or false
        return r unless r == true
      end
      if role == :self
        case resource
        when Symbol  # its an attribute
          return false unless user && user.is_self?(@last_obj)
        when Class  # classes can't be people
          return false
        else
          return false unless user && user.is_self?(resource)
          @last_obj = resource
        end
      else
        unless resource.is_a?(Symbol) || resource.is_a?(Class)
          @last_obj = resource
        end
      end

      if block_given?
        if resource != Root
          @node = @node.through force_class(resource), role, label, :allow
        end
        yield
      end
    ensure
      @node, @last_obj = hold
    end
    true
  end

  def self.explain
    @explain.join(', ')
  end
  # Check if role is able to access resource according to label
  # Returns
  #   boolean indicating access capability
  def self.allow?(resource, label, role = nil, &block)
    hold = @node
    @node ||= root
    @explain = []
    begin
      role ||= user && user.role_sym
      raise "no role" unless role
      # allow argument order changes to match node's unwinding of args
      if @node == root
        root_access = _allow?(Root, role, label, &block)
        # puts "root_access = #{root_access.inspect}"
        unless root_access.nil?
          @explain << "root access found"
          return root_access
        end
      end
      path_access = _allow?(resource, role, label, &block)
      # puts "path_access = #{path_access.inspect}"
      unless path_access.nil?
        @explain << "path access found"
        return path_access
      end
      self_access = _allow? resource, :self, label, &block
      if self_access
        @explain << "self access found"
      else
        @explain << "failed #{role} #{label} #{resource}"
      end
      return self_access || false
    ensure
      @node = hold
    end
    raise "never get here"
  end

  def self.node
    @node
  end

  def self.user=(user)
    @user = user
  end
  def self.user
    @user
  end
end
