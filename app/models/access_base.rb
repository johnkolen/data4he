class AccessBase
  @@labels = {}

  def self.define_access(label, values=nil)
    if values.is_a? Array
      @@labels[label] = values
    else
      @@labels[label] = [values || label]
    end
  end

    class Mapper
      def initialize
        @map = {}
      end
      def add key, child=nil
        if key.is_a? Array
          key.each do |k|
            add key, child
          end
        else
          @map[key] = child
        end
        child
      end
      def member? key
        @map.member? key
      end
      def empty?
        @map.empty?
      end
      def [] key
        @map[key]
      end
      def through *keys
        t = @map[keys.first]
        return t if t.nil?
        keys.shift
        return t if t.is_a? Node
        t.through *keys
      end
      def tree_str indent=""
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
        out.join("\n")
      end
    end

  class Node < Mapper
    class ADX < Mapper
      def add ad, child=nil
        raise "not allow or deny #{ad}" unless ad == :allow || ad == :deny
        super ad, child || Node.new
      end
      def allow?
        return true if @map[:allow]
        false
      end
    end

    class KindX < Mapper
      def add kind, ad, child=nil
        return self if member? kind
        adx = ADX.new
        adx.add ad
        super kind, adx
      end
      def allow? kind
        adx = self[kind]
        return false unless adx
        adx.allow?
      end
    end

    class RoleX < Mapper
      def add role, kind, ad, child=nil
        unless member? role
          kx = KindX.new
          kx.add kind, ad, child
          super role, kx
        else
          self[role].add kind, ad, child
        end
        self
      end
      def allow? role, kind
        kx = self[role]
        return false unless kx
        kx.allow? kind
      end
    end

    def initialize
      super
    end

    def add resource, role, kind, ad, child=nil
      unless member? resource
        rx = RoleX.new
        rx.add role, kind, ad, child
        super resource, rx
      else
        self[resource].add role, kind, ad, child
      end
    end

    def allow resource, kind, role
      add resource, kind, role, :allow
    end

    def deny resource, kind, role
      add resource, kind, role, :deny
    end

    def allow? resource, kind, role
      rx = self[resource]
      return false unless rx
      rx.allow? kind, role
    end
  end

  @@root = Node.new

  def self._allowdeny labels, resource, roles, kind, &block
    hold = @node
    @current = @node || @@root
    expand(labels).each do |label|
      expand(roles).each do |role|
        #puts "#{label.inspect}  #{role.inspect} #{resource}"
        @current.add resource, role, label, kind
        if block_given?
          @node = @current.through resource, role, label, kind
          yield
        end
      end
    end
    @node = hold
  end

  def self.allow labels, resource, roles, &block
    _allowdeny labels, resource, roles, :allow, &block
  end

  def self.deny labels, resource, roles, &block
    _allowdeny labels, resource, roles, :deny, &block
  end


  def self.tree_str
    @@root.tree_str
  end

  def self.expand elems
    if elems.is_a? Array
      elems.map{|elem| expand elem }.flatten
    else
      ex = @@labels[elems]
      if ex
        ex
      else
        [elems]
      end
    end
  end

  def self.allow? resource, label, role=nil, &block
    role ||= user.role_sym
    hold = @node
    @node ||= @@root
    if @node == @@root && @node.allow?(AccessRoot, label, role)
      if block_given?
        yield
      end
      if role == :self
        return user && user.is_self?(resource)
      else
        return true
      end
    end
    resource_obj = resource
    unless resource.is_a?(Class) || resource.is_a?(Symbol)
      resource = resource.class
    end
    unless @node.allow? resource, role, label
      @node = hold
      return false
    end
    if block_given?
      @node = @node.through resource, role, label
      hold_self = @last_self
      @last_self = resource_obj if role == :self
      yield
      @last_self = hold_self
    end
    @node = hold
    if role == :self
      if resource_obj.is_a? Symbol
        user && user.is_self?(@last_self)
      else
        user && user.is_self?(resource_obj)
      end
    else
      true
    end
  end

  def self.user= user
    @@user = user
  end
  def self.user
    @@user
  end
end
