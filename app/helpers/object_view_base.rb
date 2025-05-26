module ObjectViewBase
  # for testing
  def set_ov_obj(obj)
    @ov_obj = obj
  end
  def get_ov_obj
    @ov_obj
  end

  def set_ov_form(form)
    @ov_form = form
  end

  def object_view(obj)
    @ov_obj = obj
  end

  def ov_access_class
    @ov_access_class || Access
  end

  def set_ov_access_class klass
    @ov_access_class = klass
  end

  def ov_with_access_class klass, &block
    hold = @ov_access_class
    @ov_access_class = klass
    yield
    @ov_access_class = hold
  end

  # lowercase and underscores
  def ov_obj_class_name_u
    @ov_obj.class.to_s.underscore
  end

  # lowercase and dashes (kebab style)
  def ov_obj_class_name_k
    @ov_obj.class.to_s.underscore.dasherize
  end

  # humanized lowercase
  def ov_obj_class_name_h
    @ov_obj.class.to_s.humanize(capitalize: false)
  end

  ###################################

  def ov_allow? resource, label, **options, &block
    hold = @ov_access
    @ov_access ||= label
    if options[:why]
      puts "node  #{ov_access_class.node.inspect}"
      puts "allow? #{resource.inspect}\n  label #{@ov_access}\n  user #{ov_access_class.user.inspect}"
      puts "   -> #{ov_access_class.allow? resource, @ov_access}"
    end
    ov_access_class.allow? resource, @ov_access, &block
  ensure
    @ov_access = hold
  end

  ###################################

  def ov_form(obj = nil, **options, &block)
    rv = nil
    ov_allow? obj, :edit, **(options[:allow]||{}) do
      @ov_obj = obj || @ov_obj
      p = {}
      if options[:turbo]
        p = { tf: 1 }
      end
      f = form_with(model: @ov_obj,
                    url: polymorphic_path(@ov_obj, params: p),
                    class: "ov-form",
                    **options) do |form|
        @ov_form = form
        capture &block
      end
      rv = tag.div f, class: "ov-form-wrapper"
    end
    rv
  end

  ###################################

  def ov_display(obj = nil, &block)
    rv = nil
    ov_allow? obj, :view do
      return capture &block if @ov_form
      @ov_obj = obj || @ov_obj
      content = capture &block
      rv = tag.div content, id: dom_id(@ov_obj), class: "ov-display"
    end
    rv
  end

  ###################################

  def ov_fields_for(oattr, **options, &block)
    if options[:if] == :exists
      return nil unless @ov_obj.send(oattr)
    end
    hold = [ @ov_form, @ov_obj, @ov_elem ]
    rv = if @ov_form
      _ov_fields_for_form oattr, **options, &block
    else
      _ov_fields_for_display oattr, **options, &block
    end
    @ov_form, @ov_obj, @ov_elem = hold
    rv
  end


  ###################################

  def ov_with(oattr, &block)
    hold = @ov_obj
    @ov_obj =
      if @ov_obj.is_a? Array
        [ @ov_obj.first.send(oattr) ]
      else
        @ov_obj.send(oattr)
      end
    res = capture &block
    @ov_obj = hold
    res
  end

  def ov_render *args, **opts
    #puts "render #{args.inspect}, #{opts.inspect}"
    render *args, **opts
  end

  def _partial oattr
    "#{oattr.to_s.pluralize}/#{oattr}"
  end

  def _template oattr
    "#{oattr.to_s.pluralize}/#{oattr}"
  end

  def _locals oattr
    { oattr => @ov_obj }
  end

  def _get_all_objects(oattr, **options)
    elems = []
    if ov_one_to_one? oattr
      ov_with oattr do
        elems = [
          ov_render(partial: _partial(oattr),
                    locals: _locals(oattr))
        ]
      end
    else
      ov_with oattr do
        elems = @ov_obj.map do |obj|
          @ov_obj = obj
          raise "???"
          ov_render "#{oattr}/#{oattr}"  # Why isn't first pluralized?
        end.map do |x|
          tag.li x, class: "ov-object"
        end
      end
    end
    elems.join.html_safe
  end

  def _ov_fields_for_display(oattr, **options, &block)
    one2one = ov_one_to_one? oattr
    if block_given?
      # process the fields from the block
      if one2one
        # treat the attributes at the same level as parent
        @ov_obj = @ov_obj.send(oattr)
        capture(&block)
      else
        raise "TODO"
      end
    else
      # include all the allowable fields in attribute value
      elems = _get_all_objects oattr
      str = tag.div class: "ov-field" do
        [ tag.label(@ov_obj.send("#{oattr}_label"),
                    for: oattr,
                    class: @ov_form ? "form-label" : "ov-label"),
          tag.ul(elems, class: "ov-fields-for")
        ].join.html_safe
      end
      str
    end.html_safe
  end

  def ov_one_to_one?(oattr)
    r = @ov_obj.class.reflect_on_association(oattr)
    r.macro == :belongs_to && r.inverse_of.macro == :has_one
  end

  # Generate the content for all the fields of a single oattr
  # from a one-to-one association
  def _ov_fields_for_form_one(oattr, **options, &block)
    #puts "_ov_fields_for_form_one"
    obj = @ov_obj.send(oattr)
    return "" unless obj
    raise "no obj: one(#{oattr}) #{@ov_obj}" unless obj
    _ov_fields_for_form_element(oattr,
                                obj,
                                ov_obj_class_name_k,
                                0,
                                **options,
                                &block)
  end

  # Generate the content for all the fields of all the oattr
  # from a one-to-many association
  def _ov_fields_for_form_many(oattr, **options, &block)
    #puts "_ov_fields_for_form_many"
    label = @ov_obj.send("#{oattr}_label")
    out = [ '<ul class="ov-fields-for" data-ov-fields-for-target="list">',
            ov_add ]
    num = -1
    @ov_obj.send(oattr).each do |obj|
      out << _ov_fields_for_form_element(oattr,
                                         obj,
                                         ov_obj_class_name_k,
                                         num += 1,
                                         removable: true,
                                         template: obj.new_record?,
                                         **options,
                                         &block)
    end
    out << "</ul>"
    [ tag.label(label,
                for: oattr,
                class: @ov_form ? "form-label" : "ov-label"),
      out.join.html_safe
    ].join.html_safe
  end

  # name should be kebab as it's used for css classes
  def _ov_fields_for_form_element(oattr, obj, css_name, num, **options, &block)
    hold = [@ov_form, @ov_obj]
    @ov_form.fields_for oattr, obj  do |form|
      @ov_form = form
      @ov_obj = form.object
      raise "no form object: element(#{oattr},#{obj.inspect})" unless @ov_obj
      li_id = "#{css_name}-li-#{num}"
      # include object"s id  if it's been persisted
      pid = @ov_obj.persisted? ? @ov_form.hidden_field(:id) : ""
      #puts "block given = #{block_given?.inspect}"
      fields = block_given? ?
                 capture(&block) :
                 ov_render(_template(oattr), oattr => @ov_obj)
      #puts "template = #{_template(oattr)}, #{oattr} => #{@ov_obj}"
      #puts "fields = #{fields}"
      li_body = pid + fields
      li_body += ov_remove(li_id) if options[:removable]
      elem = tag.li(li_body.html_safe,
                    id: li_id,
                    class: "ov-object collapse show").html_safe
      if options[:template]
        tag.template(elem,
                     id: "ov-#{css_name}-template",
                     data: { "ov-fields-for-target": "template" })
      else
        elem
      end
    end
  ensure
    @ov_form, @ov_obj = hold
  end

  # Generate the content for all the fields of oattr
  def _ov_fields_for_form(oattr, **options, &block)
    #puts "_ov_fields_for_form"
    hold = @ov_obj
    if ov_one_to_one?(oattr)
      _ov_fields_for_form_one oattr, **options, &block
    else
      _ov_fields_for_form_many oattr, **options, &block
    end.html_safe
  ensure
    raise "ov_obj mismatch" unless @ov_obj == hold
  end
end
